#!/bin/zsh

EMACS_APP="/Applications/Emacs.app"
curl -o /tmp/doom.png https://raw.githubusercontent.com/eccentric-j/doom-icon/master/cute-doom/doom.png &&
  sips -i /tmp/doom.png >/dev/null &&
  DeRez -only icns /tmp/doom.png >/tmp/icns.rsrc &&
  Rez -append /tmp/icns.rsrc -o "$EMACS_APP"$'/Icon\r' &&
  SetFile -a C "$EMACS_APP" &&
  SetFile -a V "$EMACS_APP"$'/Icon\r'
