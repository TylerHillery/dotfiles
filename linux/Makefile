DOTFILE_PATH := $(shell pwd)
XDG_CONFIG_HOME ?= $(HOME)/.config

.PHONY: all install software dotfiles git zsh tmux oh-my-zsh atuin mise wsl-conf

$(HOME)/.%: %
	ln -sfn $(DOTFILE_PATH)/$^ $@

git: $(HOME)/.gitconfig
zsh: $(HOME)/.zshrc
tmux: $(HOME)/.tmux.conf

$(HOME)/.oh-my-zsh/custom/themes/tylerhillery.zsh-theme:
	mkdir -p $(HOME)/.oh-my-zsh/custom/themes
	ln -sfn $(DOTFILE_PATH)/tylerhillery.zsh-theme $(HOME)/.oh-my-zsh/custom/themes/tylerhillery.zsh-theme

oh-my-zsh: $(HOME)/.oh-my-zsh/custom/themes/tylerhillery.zsh-theme

$(XDG_CONFIG_HOME)/atuin/config.toml:
	mkdir -p $(XDG_CONFIG_HOME)/atuin
	ln -sfn $(DOTFILE_PATH)/atuin_config.toml $(XDG_CONFIG_HOME)/atuin/config.toml

atuin: $(XDG_CONFIG_HOME)/atuin/config.toml

$(XDG_CONFIG_HOME)/mise/config.toml:
	mkdir -p $(XDG_CONFIG_HOME)/mise
	ln -sfn $(DOTFILE_PATH)/mise_config.toml $(XDG_CONFIG_HOME)/mise/config.toml

mise: $(XDG_CONFIG_HOME)/mise/config.toml

wsl-conf:
	sudo install -m 644 $(DOTFILE_PATH)/wsl.conf /etc/wsl.conf

software:
	bash ./install.sh

dotfiles: zsh oh-my-zsh git atuin mise tmux

install: software dotfiles

all: install
