# mfunc

A function wrapper plugin for ZSH.

Define, view, edit and delete persistent functions on-the-fly, without extra steps. They are permanently available until you delete them.

The plugin defines 3 functions:

| `Command`               | Action
|-------------------------|-----------------------------------------
| `mfunc name [name] ...` | create new function(s) interactively
| `rfunc name [name] ...` | delete existing user-defined function(s)
| `lfunc [-h\|v]`         | list all user-defined functions

Functions are stored as plain text in `$MFUNDCIR` and made available via
the autoload builtin (i.e. they are only loaded into memory when called for the
first time).

## Installation

### a) As an oh-my-zsh plugin
1. Run:
`cd $ZSH/custom && git clone https://github.com/amogus07/mfunc.git plugins/mfunc`

2. Add `mfunc` to your plugins in your `.zshrc`. The relevant line should
look something like this:
`plugins=(git mfunc)`

### b) using antigen
1. Add this line where you load your antigen bundles in your `.zshrc`:

`antigen bundle amogus07/mfunc`
### c) with vanilla ZSH
1. `git clone` this repo to a location of your choice

2. add a line `source /location/of/your/choice/mfunc.plugin.zsh` to your .zshrc

Upon its first run the plugin will notify you that it created the directory in
which it stores your functions.

## Configuration

| Environment Variable | Default                                  | Description
|----------------------|------------------------------------------|------------------
| `$MFUNCDIR`          | `${ZDOTDIR/functions:-$HOME/.functions}` | functions storage

## Optional dependencies

| Dependency                          | Description
|-------------------------------------|-----------------------------------------------------------
| [highlight](https://repology.org/project/highlight) | enables syntax highlighting for `lfunc -v`

## Disclaimer

This is an early version covering only the most basic functionality. There are
no safeguards whatsover, so use at you own risk. Things like tab completion,
input sanitization and the like are on the TODO list.
