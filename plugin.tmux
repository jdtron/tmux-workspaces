#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/bin/util.sh"

split_flags='h'
key="$( tmux_get_option '@workspaces-key' 'O' )"
width="$( tmux_get_option '@workspaces-chooser-width' 40 )"
display="$( tmux_get_option '@workspaces-chooser-display' 'left' )"

if [ "${display,,}" = 'popup' ]; then
    tmux bind-key $key popup -EE $CURRENT_DIR/bin/tmuxw.sh
else
    if [ "${display,,}" = 'left' ]; then
        split_flags="${split_flags}b"
    fi
    tmux bind-key $key splitw -${split_flags} -l $width $CURRENT_DIR/bin/tmuxw.sh
fi
