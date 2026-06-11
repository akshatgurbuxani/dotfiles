#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/dotfiles"

echo "==> Installing Homebrew packages..."
brew bundle --file="$DOTFILES/Brewfile" || true

echo "==> Symlinking dotfiles..."
ln -sf "$DOTFILES/zsh/.zshrc"   "$HOME/.zshrc"
ln -sf "$DOTFILES/zsh/.zprofile" "$HOME/.zprofile"
ln -sf "$DOTFILES/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

ln -sf "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/git/.gitconfig"  "$HOME/.gitconfig"

ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"

echo "==> Setting up tmux plugin manager..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "==> Done!"
echo "   Open nvim -> :Lazy will auto-install plugins"
echo "   Open tmux -> prefix + I to install plugins"
echo "   Create ~/.zshrc.local, ~/.gitconfig.local, ~/.config/nvim/init.local.lua for machine-specific overrides"
