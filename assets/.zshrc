# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="agnosterzak"

# Starship
export PATH="$HOME/.local/bin:$PATH"
eval "$(starship init zsh)"

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
# pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# Fastfetch with standard Arch logo (for CachyOS)
fastfetch --logo arch

# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Custom Dotfiles Management
function dots() {
    ~/Imad-Arch-Hypr-Dots/maintain.sh "$@"
}

alias aurpdate='paru -Syu'
alias update='sudo pacman -Syu && paru -Sua'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
alias mirrors='sudo cachyos-rate-mirrors'

# # SiteBlocker Aliases
alias sudo='sudo '
alias siteblock='/home/imad/.config/hypr/UserScripts/siteblock'
alias sbp='sudo siteblock pause'
alias sbr='sudo siteblock resume'
alias sbs='siteblock status'
alias fixconfig='cd ~/.config && aider --model groq/llama-3.3-70b-versatile'
source ~/.my_secrets



alias ytdl='/home/imad/.config/hypr/UserScripts/ytdl-music.sh'

# opencode
export PATH=/home/imad/.opencode/bin:$PATH


# Added by Antigravity CLI installer
export PATH="/home/imad/.local/bin:$PATH"
