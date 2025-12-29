#!/usr/bin/bash
#
# source $HOME/.profile
# # source $HOME/.bashrc
# source $HOME/.zshrc
# export PATH="$HOME/go/bin:$HOME/.fzf/bin:$PATH:/usr/bin:$HOME/.local/bin"
#
# sesh connect "$(
#   $HOME/go/bin/sesh list --icons | fzf-tmux -p 80%,70% \
#     --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
#     --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
#     --bind 'tab:down,btab:up' \
#     --bind 'ctrl-a:change-prompt(⚡  )+reload($HOME/go/bin/sesh list --icons)' \
#     --bind 'ctrl-t:change-prompt(🪟  )+reload($HOME/go/bin/sesh list -t --icons)' \
#     --bind 'ctrl-g:change-prompt(⚙️  )+reload($HOME/go/bin/sesh list -c --icons)' \
#     --bind 'ctrl-x:change-prompt(📁  )+reload($HOME/go/bin/sesh list -z --icons)' \
#     --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
#     --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload($HOME/go/bin/sesh list --icons)' 
#     # --preview-window 'right:55%' \
#     # --preview '$HOME/go/bin/sesh preview {}'
# )"

# Ensure the PATH is set so tmux and fzf-tmux are found
export PATH="$HOME/go/bin:$HOME/.fzf/bin:$HOME/.local/bin:/usr/bin:/bin"

session=$(sesh list --icons | fzf-tmux --no-preview -p 80%,70% \
    --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
    --header '  ^a all ^t tmux ^g configs ^x zoxide ^d kill ^f find' \
    --bind 'tab:down,btab:up' \
    --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
    --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
    --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
    --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
    --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
    --bind 'ctrl-d:execute(tmux kill-session -t {2..})+reload(sesh list --icons)')

[[ -z "$session" ]] && exit 0
sesh connect "$session"
