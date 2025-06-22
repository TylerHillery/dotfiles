DOTFILE_PATH := $(shell pwd)

$(HOME)/.%: %
	ln -sf $(DOTFILE_PATH)/$^ $@

git: $(HOME)/.gitconfig
zsh: $(HOME)/.zshrc $(HOME)/.zsh.d 

$(HOME)/.oh-my-zsh/custom/themes/tylerhillery.zsh-theme:
	mkdir -p $(HOME)/.oh-my-zsh/custom/themes
	ln -sf $(DOTFILE_PATH)/tylerhillery.zsh-theme $(HOME)/.oh-my-zsh/custom/themes/tylerhillery.zsh-theme

oh-my-zsh: $(HOME)/.oh-my-zsh/custom/themes/tylerhillery.zsh-theme

$(HOME)/.config/ghostty/config:
	mkdir -p $(HOME)/.config/ghostty
	ln -sf $(DOTFILE_PATH)/ghostty_config $(HOME)/.config/ghostty/config

ghostty: $(HOME)/.config/ghostty/config

$(HOME)/Library/Application\ Support/Code/User/settings.json:
	mkdir -p "$(HOME)/Library/Application Support/Code/User"
	ln -sf $(DOTFILE_PATH)/vscode_settings.jsonc "$(HOME)/Library/Application Support/Code/User/settings.json"

$(HOME)/Library/Application\ Support/Code/User/keybindings.json:
	mkdir -p "$(HOME)/Library/Application Support/Code/User"
	ln -sf $(DOTFILE_PATH)/vscode_keybindings.jsonc "$(HOME)/Library/Application Support/Code/User/keybindings.json"

vscode: $(HOME)/Library/Application\ Support/Code/User/settings.json $(HOME)/Library/Application\ Support/Code/User/keybindings.json

$(HOME)/.config/mise/config.toml:
	mkdir -p $(HOME)/.config/mise
	ln -sf $(DOTFILE_PATH)/mise_config.toml $(HOME)/.config/mise/config.toml

mise: $(HOME)/.config/mise/config.toml

install:
	./install.sh

update:
	brew bundle --file=$(DOTFILE_PATH)/Brewfile
	brew bundle cleanup --file=$(DOTFILE_PATH)/Brewfile --force

all: install git zsh oh-my-zsh ghostty vscode mise