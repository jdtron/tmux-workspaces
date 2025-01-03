#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/bin/util.sh"

split_flags='h'
key="$( tmux_get_option '@workspaces-key' 'O' )"
width="$( tmux_get_option '@workspaces-chooser-width' 40 )"
orientation="$( tmux_get_option '@workspaces-chooser-orientation' 'left' )"
if [ "${orientation,,}" = 'left' ]; then
    split_flags="${split_flags}b"
fi

tmux bind-key $key splitw -${split_flags} -l $width $CURRENT_DIR/bin/tmuxw.sh
