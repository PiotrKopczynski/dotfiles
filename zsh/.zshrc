# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH="$HOME/.atuin/bin:$PATH"

# Force zsh to include hidden files in completions
setopt globdots

# --- Completion System ---
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
zstyle ':completion:*' menu select
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Carapace for showing command options
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
export CARAPACE_ZSH_FILE_COMPLETION=false
source <(carapace _carapace)
compdef _default vi nvim cd
# Force carapace to use zsh's default completion system so fzf-tab can intercept it

# Enable fzf-tab completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
# Disable default preview for all commands (prevents clutter)
zstyle ':fzf-tab:*' fzf-command fzf
# Give the fzf window a border and some padding
zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept --preview-window=right:50%:rounded --color=16 --border=rounded
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:*' popup-min-size 100 20
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza -1 --color=always $realpath'
# Preview for ANY command when completing a path
zstyle ':fzf-tab:complete:*:*' fzf-preview \
  'if [ -d $realpath ]; then \
    eza -1 --tree --color=always --icons --level=1 $realpath; \
  else \
    batcat --color=always --style=numbers $realpath 2>/dev/null || cat $realpath; \
  fi'
zstyle ':fzf-tab:complete:*' show-hidden-files yes
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

#set vim mode
ZVM_VI_SURROUND_BINDKEY=smap # This enables 'sa', 'sd', 'sr' (add, delete, replace)
ZVM_VI_HIGHLIGHT_SELECTION=true
# bindkey -v
# Path to your custom vim-mode file
ZVM_CONFIG="$HOME/.config/zsh/keybindings.zsh"
# zvm_after_init_commands+=('[ -f ~/.fzf ] && source ~/.fzf')
source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# Load the file if it exists
if [[ -f "$ZVM_CONFIG" ]]; then
    source "$ZVM_CONFIG"
fi

# Load custom aliases
if [ -f ~/.config/zsh/.zsh_aliases ]; then
	source ~/.config/zsh/.zsh_aliases
fi

# Preferred editor for local and remote sessions
export EDITOR='nvim'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Add golang
export PATH=$PATH:/usr/local/go/bin

export SSH_AUTH_SOCK=~/.1password/agent.sock

export SUDO_EDITOR=nvim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export FZF_DEFAULT_OPTS="--style full \
    --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}'"
# Ctrl+T: Files under current directory (fd for better UX)
export FZF_CTRL_T_COMMAND="fd --type f --hidden --strip-cwd-prefix -E .git -E .cache -E target -E timeshift -E .npm -E .cargo -E .rustup -E node_modules -E Steam -E Games -E go -E .java -E '.local/state' -E '.local/share' -E snap -E .m2 -E Downloads -E .var"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target,timeshift
  --preview 'batcat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Alt+C: Directories systemwide (plocate for speed, excluding .git)
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix -E .git -E .cache -E target -E timeshift -E .npm -E .cargo -E .rustup -E node_modules -E Steam -E Games -E go -E .java -E '.local/state' -E '.local/share' -E snap -E .m2 -E Downloads -E .var -E .eclipse --full-path ~"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target,timeshift
  --preview 'tree -a -C -L 2 {}'"

export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

# Add sesh to PATH
export PATH=$PATH:$HOME/go/bin

# eza completions
export FPATH="$HOME/eza/completions/zsh:$FPATH"

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

eval "$(zoxide init zsh)"
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"
eval "$(starship init zsh)"
source $HOME/.zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
