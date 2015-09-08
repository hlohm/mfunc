## mfunc
### a function wrapper plugin for oh-my-zsh

This little tool defines 3 helper functions:

| `Command`               | Action
|-------------------------|----------------------------------------
| `mfunc name [name] ...` | create new function(s) interactively
| `rfunc name [name] ...` | delete existing user-defined function(s)
| ` lfunc`                | list all user-defined functions

functions are stored as plain text in $ZSH/functions/ and made available via
the autoload builtin (i.e. they are only loaded into memory when called for the
first time).

#### Installation

Run:

`cd $ZSH/custom && git clone https://github.com/hlohm/mfunc.git plugins/mfunct4`

...and add `mfunc` to your plugins in your `.zshrc`. The relevant line schould
look something like this:
`plugins=(git mfunc)`