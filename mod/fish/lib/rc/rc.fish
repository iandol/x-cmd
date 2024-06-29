
# add path to .x-cmd.root/bin and .x-cmd.root/global/data/bin/l/j/h

if ! contains -- $HOME/.x-cmd.root/bin $PATH
    set -g PATH $HOME/.x-cmd.root/bin $PATH
end

if ! contains -- $HOME/.x-cmd.root/global/data/bin/l/j/h/bin $path
    set -g PATH $HOME/.x-cmd.root/global/data/bin/l/j/h/bin $PATH
end

set -g ___X_CMD_CD_RELM_0 $PWD

function x
    ___x_cmd $argv
end

function c
    if [ "$argv[1]" = "-" ]
        cd -
        return
    end
    ___x_cmd cd $argv
end

function ___x_cmd
    set -x ___X_CMD_CD_RELM_0               "$___X_CMD_CD_RELM_0"
    set -x ___X_CMD_THEME_RELOAD_DISABLE    "$___X_CMD_THEME_RELOAD_DISABLE"
    set -x ___X_CMD_IS_INTERACTIVE_FORCE    "$___X_CMD_IS_INTERACTIVE_FORCE"
    set -x ___X_CMD_XBINEXP_FP              "$HOME/.x-cmd.root/local/data/xbinexp/fish/$fish_pid"_(random)
    set -x ___X_CMD_XBINEXP_INITENV_OLDPWD  "$OLDPWD"
    # mkdir -p $___X_CMD_XBINEXP_FP

    bash "$HOME/.x-cmd.root/bin/xbinexp" $argv
    set exit_status $status

    set -u ___X_CMD_CD_RELM_0               "$___X_CMD_CD_RELM_0"
    set -u ___X_CMD_THEME_RELOAD_DISABLE    "$___X_CMD_THEME_RELOAD_DISABLE"
    set -u ___X_CMD_XBINEXP_FP              "$___X_CMD_XBINEXP_FP"
    set -u ___X_CMD_XBINEXP_INITENV_OLDPWD  "$___X_CMD_XBINEXP_INITENV_OLDPWD"

    if [ ! -d "$___X_CMD_XBINEXP_FP" ]
        return $exit_status
    end

    set -g ___X_CMD_XBINEXP_EVAL ""
    for file in $___X_CMD_XBINEXP_FP/*
        set varname (string replace -r '^.*/[^_]+_' '' "$file")
        if [ $varname = PWD ]
            cd (cat $file)
        else
            set -g "$varname" (cat $file)
        end
    end

    if string match -q "*xbinexp/fish*" "$___X_CMD_XBINEXP_FP"
        rm -rf "$___X_CMD_XBINEXP_FP"
    end

    if [ -n "$___X_CMD_XBINEXP_EVAL" ]
        set data "$___X_CMD_XBINEXP_EVAL"
        set -u ___X_CMD_XBINEXP_EVAL ""
        printf "%s\n" "===================" >&2
        printf ">>> %s\n\n" "$data" >&2
        printf "%s\n" "-------------------" >&2
        eval "$data"
        printf "\n%s\n" "===================" >&2
    end

    return $exit_status
end

# TODO: in the future, adding the advise

# "$HOME/.x-cmd.root/bin/xbin" prepare alias
if status is-interactive
    set -g ___X_CMD_THEME_RELOAD_DISABLE 1
    set -g ___X_CMD_IS_INTERACTIVE_FORCE 1
    # setenv ___X_CMD_CO_EXEC_SHELL=fish

    eval ("$HOME/.x-cmd.root/bin/xbin" chat --aliasinit --code)
    eval ("$HOME/.x-cmd.root/bin/xbin" writer --aliasinit --fishcode)

    # chat, writer, w
    # eval "$("$HOME/.x-cmd.root/bin/xbin" aliasinit --code)"

    alias xw='x ws'
    alias xg='x git'
    # alias xd='x docker'

    alias ,="x fish --sysco"
end