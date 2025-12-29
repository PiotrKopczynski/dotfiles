my_clipboard_copy() {
  zvm_vi_yank
  echo -n "$CUTBUFFER" | xclip -selection clipboard
}

my_clipboard_paste() {
  LBUFFER+="$(xclip -selection clipboard -o 2>/dev/null)"
}
# This function is called automatically by zsh-vi-mode
function zvm_after_init() {
  # --- Movement Remaps (j,k,l,ø -> h,j,k,l) ---
  # These commands (zvm_bindkey) ensure they work in Normal, Visual, and Oppending
  zvm_bindkey vicmd 'j' vi-backward-char
  zvm_bindkey vicmd 'k' vi-down-line-or-history
  zvm_bindkey vicmd 'l' vi-up-line-or-history
  zvm_bindkey vicmd 'ø' vi-forward-char

  zvm_bindkey visual 'j' vi-backward-char
  zvm_bindkey visual 'k' vi-down-line-or-history
  zvm_bindkey visual 'l' vi-up-line-or-history
  zvm_bindkey visual 'ø' vi-forward-char

  # --- Start/End of Line (h and æ) ---
  zvm_bindkey vicmd 'h' vi-first-non-blank
  zvm_bindkey vicmd 'æ' vi-end-of-line
  zvm_bindkey visual 'h' vi-first-non-blank
  zvm_bindkey visual 'æ' vi-end-of-line

# Register the functions as ZLE widgets
  zvm_define_widget clipboard_paste_widget my_clipboard_paste
  zvm_define_widget clipboard_copy_widget my_clipboard_copy

  # --- Paste Bindings ---
  # Bind 'p' in Normal mode and 'Ctrl+p' in Insert mode
  zvm_bindkey vicmd 'p' clipboard_paste_widget
  zvm_bindkey viins '^P' clipboard_paste_widget

  # --- Copy Binding ---
  # Bind 'y' in Visual mode
  zvm_bindkey visual 'y' clipboard_copy_widget

  # Let vim mode handle ctrl+r
  # zvm_bindkey vimcd '^R' redisplay
}
