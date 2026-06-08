#!/bin/bash

MODE_ARG=""
SKIP_GTK=false
SKIP_WALLPAPER=false
SKIP_PLANK=false
SKIP_TERMINAL=false
SKIP_EMACS=false
SKIP_TMUX=false
SKIP_ROFI=false
for arg in "$@"; do
    case "$arg" in
        dark|light) MODE_ARG="$arg" ;;
        --no-gtk) SKIP_GTK=true ;;
        --no-wallpaper) SKIP_WALLPAPER=true ;;
        --no-plank) SKIP_PLANK=true ;;
        --no-terminal) SKIP_TERMINAL=true ;;
        --no-emacs) SKIP_EMACS=true ;;
        --no-tmux) SKIP_TMUX=true ;;
        --no-rofi) SKIP_ROFI=true ;;
        *) echo "Unknown argument: $arg"; exit 1 ;;
    esac
done

# --- GTK / WM ---
LIGHT_GTK="Gruvbox-Light"
DARK_GTK="Gruvbox-Dark"
LIGHT_WM="Gruvbox-Light"
DARK_WM="Gruvbox-Dark"

# --- Icons ---
LIGHT_ICONS="Gruvbox-Plus-Light"
DARK_ICONS="Gruvbox-Plus-Dark"

# --- Wallpapers ---
LIGHT_WALLPAPER_DIR="$HOME/Pictures/wallpapers/light"
DARK_WALLPAPER_DIR="$HOME/Pictures/wallpapers/dark"

# --- Plank ---
LIGHT_PLANK="Gruvbox-Dark-BL"
DARK_PLANK="Gruvbox-Dark-BL"

# --- Terminal colors (Gruvbox) ---
LIGHT_BG="#fbf1c7"
LIGHT_FG="#3c3836"
LIGHT_CURSOR="#3c3836"
LIGHT_PALETTE="#fbf1c7;#cc241d;#98971a;#d79921;#458588;#b16286;#689d6a;#7c6f64;#928374;#9d0006;#79740e;#b57614;#076678;#8f3f71;#427b58;#3c3836"

DARK_BG="#282828"
DARK_FG="#ebdbb2"
DARK_CURSOR="#ebdbb2"
DARK_PALETTE="#282828;#cc241d;#98971a;#d79921;#458588;#b16286;#689d6a;#a89984;#928374;#fb4934;#b8bb26;#fabd2f;#83a598;#d3869b;#8ec07c;#ebdbb2"

# --- Emacs (Doom) ---
LIGHT_EMACS="gruvbox-light-soft"
DARK_EMACS="gruvbox-dark-soft"

# --- tmux-gruvbox ---
LIGHT_TMUX="light"
DARK_TMUX="dark"
TMUX_GRUVBOX_PLUGIN="$HOME/.config/tmux/plugins/tmux-gruvbox/gruvbox-tpm.tmux"

# --- Rofi ---
ROFI_CONFIG="$HOME/.config/rofi/config.rasi"
LIGHT_ROFI="/usr/share/rofi/themes/gruvbox-light.rasi"
DARK_ROFI="/usr/share/rofi/themes/gruvbox-dark.rasi"

# --- Timer helper ---
__start_ms() { __t=$(date +%s%3N); }
__end_ms() {
    local elapsed=$(( $(date +%s%3N) - __t ))
    printf "  %-18s %4dms\n" "$1" "$elapsed"
}

# --- Determine mode ---
if [[ -n "$MODE_ARG" ]]; then
    MODE="$MODE_ARG"
else
    CURRENT=$(xfconf-query -c xsettings -p /Net/ThemeName)
    if [[ "$CURRENT" == *-Dark* ]]; then
        MODE="light"
    else
        MODE="dark"
    fi
fi

# --- GTK + WM + Icons ---
if ! $SKIP_GTK; then
    __start_ms
    eval GTK_THEME='$'"${MODE^^}_GTK"
    eval WM_THEME='$'"${MODE^^}_WM"
    eval ICON_THEME='$'"${MODE^^}_ICONS"

    xfconf-query -c xsettings -p /Net/ThemeName -s "$GTK_THEME"
    xfconf-query -c xsettings -p /Net/IconThemeName -s "$ICON_THEME"
    xfconf-query -c xfwm4 -p /general/theme -s "$WM_THEME"

    if [[ "$MODE" == "dark" ]]; then
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    else
        gsettings set org.gnome.desktop.interface color-scheme 'default'
    fi
    __end_ms "GTK+WM+Icons"
fi

# --- Wallpaper ---
if ! $SKIP_WALLPAPER; then
    __start_ms
    eval WALL_DIR='$'"${MODE^^}_WALLPAPER_DIR"
    if [[ -d "$WALL_DIR" ]]; then
        WALL=$(find "$WALL_DIR" -type f | shuf -n1)
        if [[ -n "$WALL" ]]; then
            xfconf-query -c xfce4-desktop -lv | grep 'last-image' | \
            while read -r PROP _; do
                xfconf-query -c xfce4-desktop -p "$PROP" -s "$WALL"
            done
        fi
    fi
    __end_ms "Wallpaper"
fi

# --- Plank ---
if ! $SKIP_PLANK; then
    __start_ms
    eval PLANK_THEME='$'"${MODE^^}_PLANK"
    gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ theme "$PLANK_THEME"
    __end_ms "Plank"
fi

# --- Xfce4 terminal ---
if ! $SKIP_TERMINAL; then
    __start_ms
    eval BG='$'"${MODE^^}_BG"
    eval FG='$'"${MODE^^}_FG"
    eval CURSOR='$'"${MODE^^}_CURSOR"
    eval PALETTE='$'"${MODE^^}_PALETTE"

    xfconf-query -c xfce4-terminal -p /color-background -s "$BG"
    xfconf-query -c xfce4-terminal -p /color-foreground -s "$FG" 2>/dev/null || \
        xfconf-query -c xfce4-terminal -p /color-foreground -n -t string -s "$FG"
    xfconf-query -c xfce4-terminal -p /color-cursor -s "$CURSOR"
    xfconf-query -c xfce4-terminal -p /color-palette -s "$PALETTE"
    __end_ms "Terminal"
fi

# --- Emacs ---
if ! $SKIP_EMACS; then
    __start_ms
    eval EMACS_THEME='$'"${MODE^^}_EMACS"
    if command -v emacsclient &>/dev/null; then
        emacsclient -e "(progn (setq doom-theme '$EMACS_THEME) (load-theme '$EMACS_THEME t))" &>/dev/null
    fi
    __end_ms "Emacs"
fi

# --- tmux ---
if ! $SKIP_TMUX; then
    __start_ms
    eval TMUX_VARIANT='$'"${MODE^^}_TMUX"
    if command -v tmux &>/dev/null && [[ -n "$TMUX" ]]; then
        tmux set-option -g @tmux-gruvbox "$TMUX_VARIANT"
        [[ -f "$TMUX_GRUVBOX_PLUGIN" ]] && "$TMUX_GRUVBOX_PLUGIN"
    fi
    __end_ms "tmux"
fi

# --- Rofi ---
if ! $SKIP_ROFI; then
    __start_ms
    eval ROFI_THEME='$'"${MODE^^}_ROFI"
    if [[ -f "$ROFI_CONFIG" ]]; then
        sed -i 's|^@theme ".*"|@theme "'"$ROFI_THEME"'"|' "$ROFI_CONFIG"
    fi
    if pgrep -x rofi &>/dev/null; then
        killall -USR1 rofi 2>/dev/null
    fi
    __end_ms "Rofi"
fi

printf "  %-18s %s\n" "Mode" "$MODE"
notify-send "Theme Toggle" "Switched to $MODE mode"
