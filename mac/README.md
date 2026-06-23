# dotfiles

This includes my configuration for homebrew, ZSH, git, terminal emulators and other stuff.

## Requirements

* git
* make

## Install

To set up all of the files as symlinks in your home directory, just run this:

```
make all
```

## Installing with homebrew

```
make brew 
```

The original file was generated with:

```
brew bundle dump --file=Brewfile
```

## Reconciling your Brewfile

To check if you've installed packages outside of your dotfiles environment:

```
make brew-reconcile
```

## Managing tools with mise

Install all configured tools from `mise_config.toml`:

```
mise install
```

Clean up unused tool versions:

```
mise prune
```

List installed tools:

```
mise list
```