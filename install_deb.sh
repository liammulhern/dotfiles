#!/bin/bash

# Function to check if a package is installed and install it if not
install_package() {
  if ! dpkg -s "$1" &> /dev/null; then
    echo "Installing $1..."
    sudo apt update && sudo apt install -y "$1"
  else
    echo "$1 is already installed."
  fi
}

# Install required packages
install_package "zsh"
install_package "tmux"
install_package "fzf"
install_package "bat"

# Install zoxide
if ! command -v zoxide &> /dev/null; then
  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
  echo "zoxide is already installed."
fi

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

# Install Neovim
