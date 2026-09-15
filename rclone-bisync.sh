#!/bin/bash

LOG_FILE="$HOME/rclone.log"

log_msg() {
    local priority="$1"
    local message="$2"

    case "$(uname -s)" in
        Darwin)
            echo "$(date '+%Y-%m-%d %H:%M:%S') [$priority] $message" >> "$LOG_FILE"
            ;;
        *)
            logger -t rclone-bisync -p "daemon.$priority" "$message"
            ;;
    esac
}

# Prevent overlapping runs if a previous sync is still running
if pgrep -x "rclone" >/dev/null; then
    log_msg notice "Skipping run: a previous rclone process is still active"
    exit 0
fi

get_rclone_bin() {
    case "$(uname -s)" in
        Darwin) echo "/opt/homebrew/bin/rclone" ;;
        Linux)  echo "/usr/bin/rclone" ;;
        *)      log_msg err "Unsupported OS: $(uname -s)"; exit 1 ;;
    esac
}

notify() {
    local title="$1"
    local message="$2"
    local is_error="$3"

    case "$(uname -s)" in
        Darwin)
            if [ "$is_error" -ne 0 ]; then
                /opt/homebrew/bin/terminal-notifier \
                    -title "$title" \
                    -message "$message" \
                    -sound Glass \
                    -group rclone-bisync \
                    -sender com.apple.Terminal
            else
                /opt/homebrew/bin/terminal-notifier \
                    -title "$title" \
                    -message "$message" \
                    -group rclone-bisync \
                    -sender com.apple.Terminal
            fi
            ;;
        Linux)
            if [ "$is_error" -ne 0 ]; then
                /usr/bin/notify-send \
                    -u critical \
                    -a rclone-bisync \
                    "$title" \
                    "$message"
            else
                /usr/bin/notify-send \
                    -u normal \
                    -a rclone-bisync \
                    "$title" \
                    "$message"
            fi
            ;;
    esac
}

RCLONE_BIN="$(get_rclone_bin)"

case "$(uname -s)" in
    Darwin)
        LOG_ARGS=(
            --log-file "$LOG_FILE"
            --log-file-max-size 10M
            --log-file-max-age 168h
            --log-file-max-backups 3
            --log-file-compress
        )
        ;;
    *)
        LOG_ARGS=(--syslog --syslog-facility DAEMON)
        ;;
esac

"$RCLONE_BIN" bisync \
    gdrive: \
    "$HOME/GoogleDrive" \
    --exclude-from ~/scripts/rclone-exclude.txt \
    --verbose \
    "${LOG_ARGS[@]}" \
    "$@"
EXIT_CODE=$?

if [ "$EXIT_CODE" -ne 0 ]; then
    case "$(uname -s)" in
        Darwin)
            notify "rclone bisync" "Sync failed (exit $EXIT_CODE). Check: $LOG_FILE" 1
            ;;
        *)
            notify "rclone bisync" "Sync failed (exit $EXIT_CODE). Check: journalctl -t rclone -t rclone-bisync" 1
            ;;
    esac
else
    notify "rclone bisync" "Sync completed successfully." 0
fi
