#!/usr/bin/env bash

# Neovim — only fetch from GitHub on apt-based systems; elsewhere expect it via the package manager
if ! command -v nvim &>/dev/null; then
  if command -v apt &>/dev/null; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
  else
    echo "Neovim not found. Install it via your package manager."
  fi
fi

# zoxide
if ! command -v zoxide &>/dev/null; then
  if command -v curl &>/dev/null; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  else
    echo "zoxide not found. Install it via your package manager."
  fi
fi
