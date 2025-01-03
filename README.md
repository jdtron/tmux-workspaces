# tmux workspaces
A plugin to interactively select workspaces and create tmux sessions for them.

## Prerequisites
Please check the following packages are installed on your system:
- tmux
- bash
- fzf

## Installation
Clone this repository into the tmux plugins directory (`~/.tmux/plugins` or `~/.config/tmux/plugins`).

## Configuration
Configuration is done through the usage of tmux options.  

| Option                    | Default      | Description                                           |
|---------------------------|--------------|-------------------------------------------------------|
| @workspaces-root          | ~/workspaces | Workspaces root directory                             |
| @workspaces-main-session  | MAIN         | Main session name (for executing `tmuxw -m` directly) |
| @workspaces-key           | O            | Keybinding to trigger tmuxw                           |
| @workspaces-chooser-width | 40           | Width of the workspace chooser                        |

**Note**: Don't forget to include the plugin in your `tmux.conf`.

### Example
```
set -g @workspaces-root '/home/jd/code'
set -g @workspaces-main-session 'BASE'
set -g @workspaces-key 'X'
run '~/.config/tmux/plugins/workspaces/plugin.tmux'
```