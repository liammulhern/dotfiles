#!/bin/bash

# Function to check if a package is installed and install it if not
install_package() {
  if ! dpkg -s "$1" &> /dev/null; then
    echo "Installing $1..."
    sudo sudo apt install -y "$1"
  else
    echo "$1 is already installed."
  fi
}

# Install required packages
install_package "tmux"

# Set the current working directory
DOTFILES_DIR=$(pwd)

# Define target locations
TMUX_CONF="$HOME/.tmux.conf"

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

# Symlink .zshrc
create_symlink "$DOTFILES_DIR/tmux.conf" "$TMUX_CONF"
