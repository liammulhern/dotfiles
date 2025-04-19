# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

##############################
# ZInit Package Manager
##############################

# Install ZInit package manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zi ice depth=1; zinit light romkatv/powerlevel10k

zi light zsh-users/zsh-history-substring-search
zi light zsh-users/zsh-autosuggestions

##############################
# Environment Variables
##############################

# Node Version Manager Path
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Set up fzf key bindings and fuzzy completion
export PATH="$PATH:/home/liam/.fzf/bin"

# Add custom bash scripts to path
export PATH="$PATH:/home/LiamM/bin"

# Add miniconda to path
export PATH="$PATH:/c/Users/LiamM/miniconda3/Scripts"

# Bat file reader alias
export MANPAGER="zsh -c 'col -bx | bat -l man -p'"

# NVIM Path
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# Zoxide Path
export PATH="$PATH:/home/liam/.local/bin"

##############################
# Alias Settings
##############################

alias ls='ls --color'

# Obsidian notes
alias oo='cd /c/Users/LiamM/Documents/Notes'
alias or='nvim /c/Users/LiamM/Documents/Notes/00-inbox/*.md'

# Fuzzy find open in nvim
alias nf='fzf -m --preview="bat --color=always {}" --bind "enter:become(nvim {+})"'

# Python
alias py='python'
alias pip='python -m pip'

# Git
alias gs='git status'
alias gA='git add -A'
alias gC='git commit'
alias gp='git push'
alias gP='git pull'
alias gf='git fetch'

##############################
# Key Bindings
##############################

# Terminal history keybinds
bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^y' autosuggest-accept

##############################
# ZSH Terminal Settings
##############################

# Terminal History Size
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

##############################
# Shell integrations
##############################

eval "$(zoxide init --cmd cd zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#if [ -f '/c/Users/LiamM/miniconda3/Scripts/conda.exe' ]; then
#    eval "$('/c/Users/LiamM/miniconda3/Scripts/conda.exe' 'shell.zsh' 'hook')"
#fi
# <<< conda initialize <<<

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


