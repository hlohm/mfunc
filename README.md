### mfunc
#### a function wrapper plugin for ZSH

Allows you to define persistent functions on-the-fly, without the need to add
them to your config files. Your functions are permanently available until you
delete them.

The plugin defines 3 commands:

| `Command`               | Action
|-------------------------|----------------------------------------
| `mfunc [name] ...`      | create or edit function(s) interactively (prompts for a name if none given)
| `rfunc name [name] ...` | delete existing user-defined function(s)
| `lfunc`                 | list all user-defined functions and their bodies

Functions are stored as plain text files (one per function) and made
available via the `autoload` builtin, i.e. each one is only loaded into
memory the first time it's actually called.

By default functions live in `~/.functions`. To use a different location,
set `MFUNC_DIR` before sourcing the plugin, e.g.:

```sh
MFUNC_DIR=$HOME/.dotfiles/functions
source mfunc.plugin.zsh
```

#### Behavior & safety notes

- Function names are validated: they must start with a letter or `_` and
  contain only letters, numbers, `_` and `-`. Names with `/`, spaces or
  leading dots/dashes are rejected, so user input can't escape the
  functions directory or collide with shell builtins/options.
- `mfunc` asks for confirmation before overwriting an existing function.
- Writing an empty function body aborts the operation and removes the
  partially-created file instead of leaving a broken stub behind.
- `rfunc` removes both the on-disk definition and the in-memory function
  from the current shell, so the change takes effect immediately.
- `rfunc` and `lfunc` work safely on an empty functions directory.
- If `compinit`/`compdef` is loaded (e.g. via oh-my-zsh), tab-completion for
  existing function names is wired up for `rfunc`.

#### Installation

######a) As an oh-my-zsh plugin
1. Run:
`cd $ZSH/custom && git clone https://github.com/hlohm/mfunc.git plugins/mfunc`

2. Add `mfunc` to your plugins in your `.zshrc`. The relevant line should
look something like this:
`plugins=(git mfunc)`

######b) using antigen
1. Add this line where you load your antigen bundles in your `.zshrc`:

`antigen bundle hlohm/mfunc`
######c) with vanilla ZSH
1. `git clone` this repo to a location of your choice

2. add a line `source /location/of/your/choice/mfunc.plugin.zsh` to your .zshrc

Upon its first run the plugin will notify you that it created the directory in
which it stores your functions.

