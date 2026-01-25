# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH="$HOME/.atuin/bin:$PATH"

# Force zsh to include hidden files in completions
setopt globdots

# --- Completion System ---
autoload -Uz compinit
compinit
_comp_options+=(globdots)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
zstyle ':completion:*' menu select
# zstyle ':completion:*' completer _expand _complete _ignored _file
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# 1. Force hidden files globally for all completion attempts
zstyle ':completion:*' show-hidden-files yes
zstyle ':completion:*' all-files yes
# zstyle ':completion:*:paths' extra-opts --glob '.*'

# Carapace for showing command options
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
export CARAPACE_ZSH_FILE_COMPLETION=false
export CARAPACE_LENIENT=1
source <(carapace _carapace)
# Make carapace completion ignore certain commands
compdef _default vi nvim cd eza touch cp mv ln rm

source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

#set vim mode
ZVM_VI_SURROUND_BINDKEY=smap # This enables 'sa', 'sd', 'sr' (add, delete, replace)
ZVM_VI_HIGHLIGHT_SELECTION=true
# 1. Enable the built-in system clipboard integration
export ZVM_SYSTEM_CLIPBOARD_ENABLED=true
# 2. Tell it which tool to use (this avoids the logic in your current config)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Use xclip (usually more stable than xsel for piping)
ZVM_CLIPBOARD_COPY_CMD='xclip -selection clipboard'
ZVM_CLIPBOARD_PASTE_CMD='xclip -selection clipboard -o'
fi
# bindkey -v
# Path to your custom vim-mode file
ZVM_CONFIG="$HOME/.config/zsh/keybindings.zsh"
# zvm_after_init_commands+=('[ -f ~/.fzf ] && source ~/.fzf')
source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable fzf-tab completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
# Give the fzf window a border and some padding
zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept --preview-window=right:50%:rounded --color=16 --border=rounded --query=''
zstyle ':fzf-tab:*' fzf-min-height 40
zstyle ':fzf-tab:*' popup-min-size 130 40
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*' show-hidden-files yes
zstyle ':fzf-tab:complete:*' insert-space false

# 2. Optimized Preview Logic
zstyle ':fzf-tab:complete:*' fzf-preview '
  local clean="${word%%[[:space:]]*}"
  local target=$realpath
  if [[ ! -e "$target" ]]; then
    target="$PWD/$clean"
  fi

  if [ -d "$target" ]; then
    eza -1a --tree --color=always --icons --level=1 "$target" 2>/dev/null
  elif [ -f "$target" ]; then
    case "$target" in
      *.png|*.jpg|*.jpeg|*.gif|*.bmp|*.webp|*.svg|*.ico)
        chafa --size=20x10 --animate=off "$target" ;;
      *.pdf)
        # Try to show the text content of the PDF (first 50 lines)
        pdftotext "$target" - 2>/dev/null | head -n 50 || echo "PDF Binary Data"
        # Alternative: use "pdfinfo" if you prefer metadata
        # pdfinfo "$target"
        ;;
      *)
        # We add --failed-color-warning=false to bat to suppress the binary warning
        batcat --color=always --style=numbers --failed-color-warning=false "$target" 2>/dev/null || cat "$target" ;;
    esac
  fi
'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

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


# Default fzf opts with gruvbox theme
export FZF_DEFAULT_OPTS="
  --color=bg+:#3c3836,bg:#1d2021,spinner:#fb4934,hl:#928374
  --color=fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934
  --color=marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934
  --color=border:#504945
  --height=40%
  --border=rounded
"
# Ctrl+T: Files under current directory (fd for better UX)
export FZF_CTRL_T_COMMAND="fd --type f --hidden --strip-cwd-prefix -E .git -E .cache -E target -E timeshift -E .npm -E .cargo -E .rustup -E node_modules -E Steam -E Games -E go -E .java -E '.local/state' -E '.local/share' -E snap -E .m2 -E Downloads -E .var"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target,timeshift
  --preview 'fzf-preview.sh {}'
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

source $HOME/.zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
eval "$(zoxide init zsh)"
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"
eval "$(starship init zsh)"
