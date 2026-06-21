#!/bin/bash
# Install tools that aren't in apt or need newer versions

set -e

# Neovim (latest from GitHub releases)
if ! command -v nvim &>/dev/null; then
  echo "Installing Neovim..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux64.tar.gz
  rm nvim-linux64.tar.gz
  sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
fi

# zoxide (smart cd)
if ! command -v zoxide &>/dev/null; then
  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi
