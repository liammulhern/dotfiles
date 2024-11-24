#!/bin/bash

# Set the current working directory
DOTFILES_DIR=$(pwd)

# Define target locations
TMUX_CONF="$HOME/.tmux.conf"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
ZSHRC="$HOME/.zshrc"

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

# Symlink .tmux.conf
create_symlink "$DOTFILES_DIR/tmux.conf" "$TMUX_CONF"

# Ensure the nvim config directory exists
mkdir -p "$NVIM_CONFIG_DIR"

# Symlink init.lua
create_symlink "$DOTFILES_DIR/nvim" "$NVIM_CONFIG_DIR"

# Symlink .zshrc
create_symlink "$DOTFILES_DIR/.zshrc" "$ZSHRC"

echo "Dotfiles symlinked successfully!"
