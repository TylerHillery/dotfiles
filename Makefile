DOTFILE_PATH := $(shell pwd)
XDG_CONFIG_HOME ?= $(HOME)/.config

$(HOME)/.%: %
	ln -sf $(DOTFILE_PATH)/$^ $@

git: $(HOME)/.gitconfig
zsh: $(HOME)/.zshrc $(HOME)/.zsh.d 

$(HOME)/.oh-my-zsh/custom/themes/tylerhillery.zsh-theme:
	mkdir -p $(HOME)/.oh-my-zsh/custom/themes
	ln -sf $(DOTFILE_PATH)/tylerhillery.zsh-theme $(HOME)/.oh-my-zsh/custom/themes/tylerhillery.zsh-theme

oh-my-zsh: $(HOME)/.oh-my-zsh/custom/themes/tylerhillery.zsh-theme

$(XDG_CONFIG_HOME)/ghostty/config:
	mkdir -p $(XDG_CONFIG_HOME)/ghostty
	ln -sf $(DOTFILE_PATH)/ghostty_config $(XDG_CONFIG_HOME)/ghostty/config

$(XDG_CONFIG_HOME)/ghostty/vim.ghostty:
	ln -sf $(DOTFILE_PATH)/vim.ghostty $(XDG_CONFIG_HOME)/ghostty/vim.ghostty

ghostty: $(XDG_CONFIG_HOME)/ghostty/config $(XDG_CONFIG_HOME)/ghostty/vim.ghostty

$(HOME)/Library/Application\ Support/Code/User/settings.json:
	mkdir -p "$(HOME)/Library/Application Support/Code/User"
	ln -sf $(DOTFILE_PATH)/vscode_settings.jsonc "$(HOME)/Library/Application Support/Code/User/settings.json"

$(HOME)/Library/Application\ Support/Code/User/keybindings.json:
	mkdir -p "$(HOME)/Library/Application Support/Code/User"
	ln -sf $(DOTFILE_PATH)/vscode_keybindings.jsonc "$(HOME)/Library/Application Support/Code/User/keybindings.json"

vscode: $(HOME)/Library/Application\ Support/Code/User/settings.json $(HOME)/Library/Application\ Support/Code/User/keybindings.json

$(XDG_CONFIG_HOME)/mise/config.toml:
	mkdir -p $(XDG_CONFIG_HOME)/mise
	ln -sf $(DOTFILE_PATH)/mise_config.toml $(XDG_CONFIG_HOME)/mise/config.toml

mise: $(XDG_CONFIG_HOME)/mise/config.toml

install:
	./install.sh

brew:
	brew bundle --file=$(DOTFILE_PATH)/Brewfile
	brew bundle cleanup --file=$(DOTFILE_PATH)/Brewfile --force

brew-reconcile:
	@echo "Dumping current brew state and comparing with Brewfile..."
	brew bundle dump --file=$(DOTFILE_PATH)/Brewfile.current --force
	@grep -v '^go ' $(DOTFILE_PATH)/Brewfile.current > $(DOTFILE_PATH)/Brewfile.current.tmp && mv $(DOTFILE_PATH)/Brewfile.current.tmp $(DOTFILE_PATH)/Brewfile.current
	@echo "\nDifferences between your Brewfile and current installed packages:"
	@echo "Lines starting with '<' are in your Brewfile but not installed"
	@echo "Lines starting with '>' are installed but not in your Brewfile"
	@bash -c 'diff --color=always <(grep -v "^#" $(DOTFILE_PATH)/Brewfile | grep -v "^$$" | sort) <(grep -v "^#" $(DOTFILE_PATH)/Brewfile.current | grep -v "^$$" | sort) || true'
	@echo "\nTo update your Brewfile with currently installed packages:"
	@echo "  mv Brewfile.current Brewfile"
	@echo "To clean up the temporary file:"
	@echo "  rm Brewfile.current"

all: install git zsh oh-my-zsh ghostty vscode mise
