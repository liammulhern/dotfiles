# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Install

### 1. Install chezmoi

```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

### 2. Apply dotfiles

```bash
chezmoi init --source ~/Projects/dotfiles --apply
```

Or from GitHub:

```bash
chezmoi init --apply liam-mulhern
```

## What's managed

| Tool | Config |
|------|--------|
| zsh | `~/.zshrc` (Powerlevel10k, zinit, fzf, zoxide) |
| tmux | `~/.config/tmux/tmux.conf` (tokyo-night, tpm) |
| nvim | `~/.config/nvim/` (kickstart.nvim + custom plugins) |
| hyprland | `~/.config/hypr/` (hyprland, hyprlock, hypridle + scripts) |
| waybar | `~/.config/waybar/` (config, style.css) |
| kitty | `~/.config/kitty/` (kitty.conf, theme.conf, themes) |
| swaync | `~/.config/swaync/` (config.json, style.css, icons, images) |
| wofi | `~/.config/wofi/style.css` |
| ghostty | `~/.config/ghostty/config` |
| fastfetch | `~/.config/fastfetch/` (multiple layouts) |
| yazi | `~/.config/yazi/` (keymap, packages, yamb plugin) |
| wlogout | `~/.config/wlogout/` (layout, style.css, icons) |
| bin scripts | `~/.local/bin/` (og, on, pf) |

## How it works

chezmoi reads the source directory and applies files to the home directory using naming conventions:

- `dot_*` → `.` prefix in filename (e.g. `dot_zshrc` → `~/.zshrc`)
- `dot_config/nvim/` → `~/.config/nvim/`
- `executable_*` → file gets executable bit set
- `.chezmoiscripts/run_once_*` → run once on first apply (package/tool installation)

## Dependencies

The `run_once` scripts install:

- **apt**: zsh, fzf, bat, tmux
- **curl**: neovim (latest release), zoxide

## Neovim plugins

LSP servers and treesitter parsers are installed automatically by Mason and lazy.nvim on first launch.

## Windows

> [!WARNING]
> Set execution policy before running: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned` (as administrator)

Windows config is not yet managed by chezmoi. Dependencies:

- pwsh, komorebi, zoxide, fzf, oh-my-posh, nvim, vscode, powertoys
- [Source Code Pro Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/SourceCodePro.zip)
