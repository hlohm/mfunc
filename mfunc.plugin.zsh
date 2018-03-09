# mfunc - meta function plugin for oh-my-zsh
#
# a wrapper for easier use of zshell's functions/autoload capabilities
#
# hlohm 2015
# github.com/hlohm
##################


#
# init
######

# this is where our functions live
fdir=${ZDOTDIR:-${HOME}}/.functions

# check if functions directory exists, create if it doesn't
if [[ ! -d $fdir/ ]]; then
    mkdir $fdir/
    echo "mfunc init: functions directory created in $fdir"
fi

# check if fpath contains our fdir, add it if it doesn't
if (( ! ${fpath[(I)$fdir]} )); then
    fpath=($fdir $fpath)
fi

# autoload any functions in functions directory
if [[ -e $fdir/* ]]; then
   autoload $(ls $fdir/)
fi

#
#functions
##########

# helpers
_mf_yesorno()
{
    # variables
    local question="${1}"
    local prompt="${question} "
    local yes_RETVAL="0"
    local no_RETVAL="3"
    local RETVAL=""
    local answer=""

    # read-eval loop
    while true ; do
        printf $prompt
        read -r answer

        case ${answer:=${default}} in
            Y|y|YES|yes|Yes )
                RETVAL=${yes_RETVAL} && \
                    break
                ;;
            N|n|NO|no|No )
                RETVAL=${no_RETVAL} && \
                    break
                ;;
            * )
                echo "Please provide a valid answer (y or n)"
                ;;
        esac
    done

    return ${RETVAL}
}

function _mf_define() {
            touch $fdir/$i
            chmod +x $fdir/$i
            echo "enter function '$i' and finish with CTRL-D"
            cat >$HOME/.functions/$i
            echo "new function '$i' created in $fdir"
            autoload $(ls $fdir/)
            echo "function is now available"
}

# make function(s)
function mfunc() {

    # berate user if no arguments given
    # TODO: interactive mode
    if (($# == 0))
    then
        echo "usage: mfunc [function name]"
    else
        for i do;
        # TODO: input sanitization
            if [[ -e $fdir/$i ]]
            then
                if _mf_yesorno "function $i already exists, overwrite? (Y/n)"
                then
                    unfunction $1   # forget the old version first
                    _mf_define $i
                else
                    echo "aborted"
               fi
            else
                _mf_define $i
            fi
        done
    fi
}

# remove function(s)
function rfunc() {

    # demand argument
    # TODO: interactive mode
    if (($# == 0)) ; then
        echo "please name at least one function to delete";
    fi

    # TODO: autocompletion/wildcards
    for i; do
        if [ -e $fdir/$i ]; then
            rm $fdir/$i
            echo "function $i removed"
        else
            echo "function $i not found"
        fi
    done
    echo "functions might still be available until next login"
}

# list functions
function lfunc() {
    # TODO: specific functions, wildcards, names only OR name + definition
    for f in $(ls $fdir); do
        echo $f "() {"; cat $fdir/$f; echo "}\n"
    done
}
