#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/bin/util.sh"

key="$( tmux_get_option '@workspaces-key' 'O' )"
width="$( tmux_get_option '@workspaces-chooser-width' 40 )"
tmux bind-key $key run-shell "tmux splitw -hl $width $CURRENT_DIR/bin/tmuxw.sh"
