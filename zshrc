##############
# BASIC SETUP
##############

# oh my zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="tylerhillery"
plugins=(git)
source $ZSH/oh-my-zsh.sh

#############
## PRIVATE ##
#############

local private="${HOME}/.zsh.d/private.sh"
if [ -e ${private} ]; then
  . ${private}
fi

#########
# Aliases
#########

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

#########
# env 
#########

# general
export EDITOR="nvim"
export TERM=xterm-256color # fixed ghostty ssh backspace

# specific python packages require this
export PKG_CONFIG_PATH="/opt/homebrew/opt/mysql-client/lib/pkgconfig"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# Tool environments
. "$HOME/.cargo/env"
. "$HOME/.atuin/bin/env"

# atuin for better ctrl+r
eval "$(atuin init zsh --disable-up-arrow)"

# manage versions across various tools
eval "$(mise activate zsh)"



