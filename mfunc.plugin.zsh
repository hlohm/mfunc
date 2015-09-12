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

# make sure functions directory exists
if [ ! -d $HOME/.functions/ ]; then
    mkdir $HOME/.functions/
    echo "mfunc init: functions directory created in $ZSH"
fi

# autoload any functions in functions directory
[[ ! -e $HOME/.functions/* ]] && autoload $(ls $HOME/.functions/)


#
#functions
##########

# helpers
mf_yesorno()
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

function mf_define() {
            touch $HOME/.functions/$i
            chmod +x $HOME/.functions/$i
            echo "enter function '$i' and finish with CTRL-D"
            cat >$HOME/.functions/$i
            echo "new function '$i' created in $HOME/.functions"
            autoload $(ls $HOME/.functions/)
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
            if [[ -e $HOME/.functions/$i ]]
            then
                if mf_yesorno "function $i already exists, overwrite? (Y/n)"
                then
                    mf_define $i
                else
                    echo "aborted"
               fi
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
        if [ -e $HOME/.functions/$i ]; then
            rm $HOME/.functions/$i
            echo "function $i removed"
        else
            echo "function $i not found"
        fi
    done
    echo "functions will still be available until next login"
}

# list functions
function lfunc() {
    # TODO: specific functions, wildcards
    for f in $(ls $HOME/.functions/); do
        echo $f "() {"; cat $HOME/.functions/$f; echo "}\n"
    done
}
