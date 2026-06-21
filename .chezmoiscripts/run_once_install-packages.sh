#!/usr/bin/env bash

install_apt() {
  sudo apt update -q
  for pkg in zsh fzf bat tmux; do
    if ! dpkg -s "$pkg" &>/dev/null; then
      sudo apt install -y "$pkg"
    fi
  done
}

install_pacman() {
  sudo pacman -S --needed --noconfirm zsh fzf bat tmux
}

install_dnf() {
  sudo dnf install -y zsh fzf bat tmux
}

if command -v apt &>/dev/null; then
  install_apt
elif command -v pacman &>/dev/null; then
  install_pacman
elif command -v dnf &>/dev/null; then
  install_dnf
else
  echo "No supported package manager found. Install manually: zsh fzf bat tmux"
fi
