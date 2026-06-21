#!/bin/bash
# Install apt packages required by these dotfiles

set -e

install_package() {
  if ! dpkg -s "$1" &>/dev/null; then
    echo "Installing $1..."
    sudo apt install -y "$1"
  fi
}

sudo apt update -q

install_package zsh
install_package fzf
install_package bat
install_package tmux
