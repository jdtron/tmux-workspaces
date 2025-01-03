#!/usr/bin/env bash

DEFAULT_ROOT_DIR="$HOME/workspaces"
DEFAULT_MAIN_SESSION='MAIN'

root_dir="$DEFAULT_ROOT_DIR"
main_session="$DEFAULT_MAIN_SESSION"
spawn_main_only=false

usage="Usage: $( basename "$0" ) [OPTIONS]

OPTIONS
    -r <path>   Root dir
    -m          Attach to main sessoin and exit
    -M <name>   Set main session name
"

# Parse cli args
parse_args() {
    while getopts 'r:mM:' arg; do
        case "$arg" in
            'r') root_dir="$OPTARG" ;;
            'm') spawn_main_only=true ;;
            'M') main_session="$OPTARG" ;;
            \?) echo -e "Invalid argument\n\n$usage" ; exit 1 ;;
        esac
    done
}

# Get tmux option
tmux_get_option() {
    local opt="$1"      # str
    local default="$2"  # str

    local value="$( tmux show-option -gqv "$opt" )"
    if [ -n "$value" ]; then
        echo "$value"
    else
        echo "$default"
    fi
}

# Load configuration options from tmux
load_config() {
    root_dir="$( tmux_get_option '@workspaces-root' "$DEFAULT_ROOT_DIR" )"
    main_session="$( tmux_get_option '@workspaces-main-session' "$DEFAULT_MAIN_SESSION" )"
}

# Check if tmux has a main session open
has_main_session() {
    tmux has-session -t "$main_session" &>/dev/null
    return $?
}

# Spawn a new main session
spawn_main_session() {
    if ! has_main_session; then
        tmux new-session -d -s "$main_session" &>/dev/null
    fi
}

# Attach to main session
attach_main_session() {
    if ! has_main_session; then
        spawn_main_session
    fi

    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$main_session"
    else
        tmux new-session -s "$main_session" -A
    fi
}

# Run fzf to choose a workspace
choose_workspace() {
    local dir_root="$1"

    choices="$( ls -1 "$dir_root" )"
    fzf <<<"$choices"
    return $?
}

# Check if the directory is a subdirectory ending with .d
is_subdir() {
    local dir="$1"

    case "$dir" in
        *.d) return 0 ;;
        *) return 1 ;;
    esac
}

main() {
    load_config
    parse_args "$@"

    if [ $spawn_main_only == true ]; then
        attach_main_session
        exit 0
    fi

    selected="$( choose_workspace "$root_dir" )" || exit 0
    selected_dir="$root_dir/$selected"

    parent=
    while is_subdir "$selected_dir"; do
        parent="$selected_dir"
        selected="$( choose_workspace "$selected_dir" )" || exit 0
        selected_dir="$parent$selected"
    done

    spawn_main_session
    tmux switch-client -t "$parent$selected" 2>/dev/null && exit 0
    tmux new-session -d -c "$selected_dir" -s "${parent}${selected}" &>/dev/null \
        && tmux switch-client -t "${parent}${selected}" &>/dev/null \
        || tmux new-session -c "$selected_dir" -s "${parent}${selected}" -A &>/dev/null
}

main "$@"
