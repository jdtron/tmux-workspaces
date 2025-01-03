set export

plugin_dir := `tmux show-env -g TMUX_PLUGIN_MANAGER_PATH | cut -d = -f2 | sed 's|/$||' || echo $HOME/.config/tmux/plugins`

install:
    #!/usr/bin/env bash
    BIN_DIR="$HOME/.local/bin"
    test -d "$BIN_DIR" || BIN_DIR="$HOME/.bin"
    install -Dm755 bin/tmuxw.sh "$BIN_DIR/tmuxw"
    TARGET_DIR="{{plugin_dir}}/workspaces"
    install -Dm755 plugin.tmux "$TARGET_DIR/plugin.tmux"
    find bin -type f -exec install -Dm755 {} "$TARGET_DIR/{}" \;
