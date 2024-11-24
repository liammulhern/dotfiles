#!/bin/bash

find . -mindepth 2 -maxdepth 2 -type f -name "install_deb.sh" -execdir bash {} \;

echo "Dotfiles symlinked successfully!"
