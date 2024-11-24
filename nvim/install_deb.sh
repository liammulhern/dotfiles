#!/bin/bash

# Install Neovim
if ! command -v nvim &> /dev/null; then
  echo "Installing Neovim..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux64.tar.gz
  sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
  echo "Neovim installed successfully!"
else
  echo "Neovim is already installed."
fi

# Set the current working directory
DOTFILES_DIR=$(pwd)

NVIM_CONFIG_DIR="$HOME/.config/nvim"

# Create symlinks function
create_symlink() {
  local src=$1
  local dest=$2

  if [ -L "$dest" ]; then
    echo "Symlink already exists for $dest. Skipping..."
  elif [ -e "$dest" ]; then
    echo "A file or directory exists at $dest. Backing it up to $dest.bak..."
    mv "$dest" "$dest.bak"
  fi

  ln -s "$src" "$dest"
  echo "Created symlink: $src -> $dest"
}

# Ensure the nvim config directory exists
mkdir -p "$NVIM_CONFIG_DIR"

# Symlink init.lua
create_symlink "$DOTFILES_DIR/nvim" "$NVIM_CONFIG_DIR"
