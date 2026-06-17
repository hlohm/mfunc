# mfunc - meta function plugin for ZSH
#
# A wrapper for easier use of zsh's function/autoload capabilities. Lets you
# define, list and remove persistent custom shell functions on-the-fly,
# without hand-editing your dotfiles. Functions are stored as plain text
# files and loaded lazily via `autoload`, so they cost nothing until used.
#
# Commands:
#   mfunc name [name...]   create (or edit) function(s) interactively
#   rfunc name [name...]   delete existing user-defined function(s)
#   lfunc                  list all user-defined functions and their bodies
#
# Override where functions are stored by setting MFUNC_DIR before sourcing
# this file, e.g.: MFUNC_DIR=$HOME/.dotfiles/functions
#
# hlohm 2015-2026
# github.com/hlohm/mfunc
##################


#
# init
######

# this is where our functions live
: ${MFUNC_DIR:=$HOME/.functions}
fdir=$MFUNC_DIR

# check if functions directory exists, create it if it doesn't
if [[ ! -d $fdir ]]; then
    if ! mkdir -p "$fdir" 2>/dev/null; then
        print -u2 "mfunc init: could not create functions directory $fdir"
        return 1
    fi
    echo "mfunc init: functions directory created in $fdir"
fi

# check if fpath contains our fdir, add it if it doesn't
if (( ! ${fpath[(I)$fdir]} )); then
    fpath=($fdir $fpath)
fi

# autoload any functions already present in the functions directory.
# the (N) glob qualifier makes this expand to nothing (instead of erroring)
# when the directory is empty; (:t) strips the directory, leaving just names.
_mf_existing=($fdir/*(N:t))
(( ${#_mf_existing} )) && autoload -Uz -- $_mf_existing
unset _mf_existing


#
# helpers
#########

# is $1 a safe function/file name? rejects empty names, path separators,
# leading dots/dashes and anything that isn't a normal identifier, so user
# input can never be used to escape $fdir or collide with shell options.
_mf_valid_name()
{
    local name="$1"

    if [[ -z $name ]]; then
        print -u2 "mfunc: function name must not be empty"
        return 1
    fi

    if [[ ! $name =~ '^[A-Za-z_][A-Za-z0-9_-]*$' ]]; then
        print -u2 "mfunc: '$name' is not a valid function name (use letters, numbers, _ and -, starting with a letter or _)"
        return 1
    fi

    return 0
}

# prompt $1 until the user answers yes (RETVAL 0) or no (RETVAL 3).
# $2, if given, is used as the answer when input can't be read (e.g. stdin
# closed), so the loop can't hang or misbehave in non-interactive contexts.
_mf_yesorno()
{
    local question="${1}"
    local default="${2}"
    local answer

    while true; do
        printf '%s ' "$question"

        if ! read -r answer; then
            answer=$default
        fi

        case ${answer:-$default} in
            Y|y|YES|yes|Yes)
                return 0
                ;;
            N|n|NO|no|No)
                return 3
                ;;
            *)
                echo "Please provide a valid answer (y or n)"
                ;;
        esac
    done
}

# (re)write a single function's body from stdin and load it. assumes $1 has
# already been validated by _mf_valid_name.
_mf_define()
{
    local name="$1"

    if ! touch "$fdir/$name" 2>/dev/null; then
        print -u2 "mfunc: could not create $fdir/$name"
        return 1
    fi
    chmod +x "$fdir/$name" 2>/dev/null

    echo "enter function '$name' and finish with CTRL-D"
    if ! cat > "$fdir/$name"; then
        print -u2 "mfunc: failed writing $fdir/$name"
        return 1
    fi

    if [[ ! -s $fdir/$name ]]; then
        echo "mfunc: '$name' was left empty, discarding"
        rm -f "$fdir/$name"
        return 1
    fi

    echo "new function '$name' created in $fdir"
    autoload -Uz -- "$name"
    echo "function is now available"
}


#
# functions
###########

# make function(s)
function mfunc()
{
    local i ret=0

    # interactive mode: no name given on the command line, so ask for one
    if (( $# == 0 )); then
        local name
        printf 'function name: '
        if ! read -r name || [[ -z $name ]]; then
            echo "usage: mfunc [function name] ..."
            return 1
        fi
        set -- "$name"
    fi

    for i in "$@"; do
        if ! _mf_valid_name "$i"; then
            ret=1
            continue
        fi

        if [[ -e $fdir/$i ]]; then
            if _mf_yesorno "function $i already exists, overwrite? (Y/n)" "n"; then
                unfunction -- "$i" 2>/dev/null   # forget the old version first
                _mf_define "$i" || ret=1
            else
                echo "aborted"
            fi
        else
            _mf_define "$i" || ret=1
        fi
    done

    return $ret
}

# remove function(s)
function rfunc()
{
    local i ret=0

    if (( $# == 0 )); then
        echo "usage: rfunc [function name] ..."
        return 1
    fi

    for i in "$@"; do
        if ! _mf_valid_name "$i"; then
            ret=1
            continue
        fi

        if [[ -e $fdir/$i ]]; then
            rm -f "$fdir/$i"
            unfunction -- "$i" 2>/dev/null   # remove from the running shell too
            echo "function $i removed"
        else
            echo "function $i not found"
            ret=1
        fi
    done

    return $ret
}

# list functions
function lfunc()
{
    local f
    local -a fns

    fns=($fdir/*(N:t))

    if (( ${#fns} == 0 )); then
        echo "no functions defined yet"
        return 0
    fi

    for f in $fns; do
        echo "$f () {"
        cat -- "$fdir/$f"
        echo "}"
        echo
    done
}

# basic tab-completion of existing function names for rfunc, only if the
# compdef framework is loaded (e.g. via oh-my-zsh or `compinit`).
if (( ${+functions[compdef]} )); then
    _mfunc_complete_existing()
    {
        local -a fns
        fns=($fdir/*(N:t))
        _describe 'function' fns
    }
    compdef _mfunc_complete_existing rfunc
fi
