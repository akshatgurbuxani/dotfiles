# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/akshatgurbuxani/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/akshatgurbuxani/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/akshatgurbuxani/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/akshatgurbuxani/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="$HOME/.local/bin:$PATH"

# opencode
export PATH=/Users/akshatgurbuxani/.opencode/bin:$PATH

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- fzf ---
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border --preview-window=right:60%"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers {} 2>/dev/null || eza --icons --tree {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons --tree {}'"

# --- zoxide ---
eval "$(zoxide init zsh)"

# --- eza ---
alias ls="eza --icons"
alias ll="eza -la --icons"
alias lt="eza --tree --icons"
alias la="eza -la --icons --git"

# --- yazi ---
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
function _open_yazi() { yazi }
zle -N _open_yazi
bindkey '^g' _open_yazi

# --- bat ---
alias cat="bat"
export BAT_THEME="Dracula"

# Added by Antigravity
export PATH="/Users/akshatgurbuxani/.antigravity/antigravity/bin:$PATH"

# Machine-local overrides (not tracked in git)
[[ ! -f ~/.zshrc.local ]] || source ~/.zshrc.local
