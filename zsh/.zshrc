export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH="$HOME/.atuin/bin:$PATH"

# Force zsh to include hidden files in completions
setopt globdots

source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable fzf-tab completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
# Give the fzf window a border and some padding
zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept --preview-window=right:50%:rounded --color=16 --border=rounded --height=100% --query=''
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:*' popup-min-size 120 20
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*' show-hidden-files yes
zstyle ':fzf-tab:complete:*' insert-space false

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

# Options to keep directory hopping history
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

# Add sesh to PATH
export PATH=$PATH:$HOME/go/bin

# eza completions
export FPATH="$HOME/eza/completions/zsh:$FPATH"

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# source $HOME/.zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
eval "$(zoxide init zsh)"
if [[ "$OSTYPE" == "darwin"* ]]; then
    . "$HOME/.atuin/bin"
    export JAVA_HOME=$(/usr/libexec/java_home -v 21) # needed for maven to use java 21
    export PATH=$JAVA_HOME/bin:$PATH
    # Set spring boot dev profile locally
    export SPRING_PROFILES_ACTIVE=dev
    export PATH=/opt/homebrew/opt/libpq/bin:$PATH
fi
eval "$(atuin init zsh)"
eval "$(starship init zsh)"
