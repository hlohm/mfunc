# mfunc - meta function plugin for oh-my-zsh
#
# a wrapper for easier use of zshell's functions/autoload capabilities
#
# hlohm 2015
# github.com/hlohm
##################

# this is where our functions live
[[ -v MFUNCDIR ]] || {
    MFUNCDIR="$HOME/.functions"
    [[ -v ZDOTDIR ]] &&
        MFUNCDIR="$ZDOTDIR/functions"
    export MFUNCDIR
}
	

# check if functions directory exists, create if it doesn't
[[ -d $MFUNCDIR/ ]] || {
    mkdir $MFUNCDIR/
    echo "mfunc init: functions directory created in $MFUNCDIR"
}

# add MFUNC_FUNCTIONS_D to fpath
MFUNC_FUNCTIONS_D="$(dirname $0)/functions"
fpath=($MFUNC_FUNCTIONS_D "${fpath[@]}" )

# check if fpath contains our MFUNCDIR, add it if it doesn't
(( ! ${fpath[(I)$MFUNCDIR]} )) &&
    fpath=($MFUNCDIR $fpath)

# autoload functions
for file in $MFUNC_FUNCTIONS_D/* $MFUNCDIR/*; do
    autoload $(basename $file)
done
