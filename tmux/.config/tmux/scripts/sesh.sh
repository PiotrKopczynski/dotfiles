#!/usr/bin/env bash

# Ensure the PATH is set so tmux and fzf-tmux are found
export PATH="$HOME/go/bin:$HOME/.fzf/bin:$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
# Ensure we have the current tmux socket and path
export TMUX_PANE_CURRENT="$TMUX_PANE"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    SESH_BIN="$HOME/go/bin/sesh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    SESH_BIN="/opt/homebrew/bin/sesh"
fi


session=$($SESH_BIN list --icons | fzf-tmux --no-preview -p 80%,70% \
    --no-sort --ansi --border-label " sesh " --prompt '⚡  ' \
    --header '  ^a all ^t tmux ^g configs ^x zoxide ^d kill ^f find' \
    --bind 'tab:down,btab:up' \
    --bind "ctrl-a:change-prompt(⚡  )+reload(TMUX=$TMUX TMUX_PANE=$TMUX_PANE $SESH_BIN list --icons --A || true)" \
    --bind "ctrl-t:change-prompt(🪟  )+reload(TMUX=$TMUX TMUX_PANE=$TMUX_PANE $SESH_BIN list -t --icons || true)" \
    --bind "ctrl-g:change-prompt(⚙️  )+reload(TMUX=$TMUX TMUX_PANE=$TMUX_PANE $SESH_BIN list -c --icons || true)" \
    --bind "ctrl-x:change-prompt(📁  )+reload(TMUX=$TMUX TMUX_PANE=$TMUX_PANE $SESH_BIN list -z --icons || true)" \
    --bind "ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~ || true)" \
    --bind "ctrl-d:execute(tmux kill-session -t {2..})+reload(sleep 0.1; TMUX=$TMUX TMUX_PANE=$TMUX_PANE $SESH_BIN list --icons || true)")

[[ -z "$session" ]] && exit 0
$SESH_BIN connect "$session"
