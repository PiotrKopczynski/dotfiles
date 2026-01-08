function zvm_after_init() {
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
}
