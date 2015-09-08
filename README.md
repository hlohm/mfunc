## mfunc
#### a function wrapper plugin for oh-my-zsh

This is handy for defining functions on-the-fly that will last longer than your
current login session without editing any config files.

The plugin defines 3 functions:

| `Command`               | Action
|-------------------------|----------------------------------------
| `mfunc name [name] ...` | create new function(s) interactively
| `rfunc name [name] ...` | delete existing user-defined function(s)
| `lfunc`                 | list all user-defined functions

functions are stored as plain text in $ZSH/functions/ and made available via
the autoload builtin (i.e. they are only loaded into memory when called for the
first time).

#### Installation

1. Run:

`cd $ZSH/custom && git clone https://github.com/hlohm/mfunc.git plugins/mfunc`

2. Add `mfunc` to your plugins in your `.zshrc`. The relevant line schould
look something like this:

`plugins=(git mfunc)`

#### Disclaimer

This is an early version covering only the most basic functionality. There are
no safeguards whatsover, so use at you own risk.
