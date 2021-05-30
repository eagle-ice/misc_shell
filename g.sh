#!/bin/bash

function g () {
    if [[ -z "$1" ]]; then
        echo "Usage: g <regex> [cd or vim/0 or 1] [sync]"
        return
    fi
    local T=$HOME
    local LOCAL_PATH=`pwd`
    #local L_PATH=$(echo $LOCAL_PATH | sed -n 's/\///g;p' |sed -n 's/\//-/g;p')
    #local OUT_DIR=$T/.g/$L_PATH

    TMP_PATH=$LOCAL_PATH

    local root_file=
    #echo $TMP_PATH
    root_path=$(find $TMP_PATH -maxdepth 1 -type d -name ".git" -o -name ".repo" -o -name ".root")
    while [ "x$root_path" == "x" ]; do
        if [[ -z $root_path ]]; then
            if [ "x$T" == "x$TMP_PATH" ]; then
                TMP_PATH=$LOCAL_PATH
                break;
            fi
            TMP_PATH=$(dirname $TMP_PATH)
            #echo "$TMP_PATH"
        fi
        root_path=$(find $TMP_PATH -maxdepth 1 -type d -name ".git" -o -name ".repo" -o -name ".root")
    done
    for i in $root_path; do
        root_file=$(basename ${i})
        if [ ! -z $root_file ]; then
            break;
        fi
    done
    echo $root_file $TMP_PATH

    local OUT_DIR=$T/.g$TMP_PATH
    local FILELIST
    if [ ! "$OUT_DIR" = "" ]; then
        mkdir -p $OUT_DIR
    fi
    FILELIST=$OUT_DIR/filelist
    echo $FILELIST $1 $2 $3
    if [[ ! -f $FILELIST ]] || [[ ! -z $3 ]]; then
        echo -n "Creating index..."
        #(\cd $T; find . -wholename ./out -prune -o -wholename ./.repo -prune -o -type f > $FILELIST)
        (find $TMP_PATH -type f | grep -v "\.git" > $FILELIST)
        echo " Done"
        echo ""
    fi
    local lines
    lines=($(\grep "$1" $FILELIST | sed -e 's/\/[^/]*$//' | sort | uniq))
    if [[ ${#lines[@]} = 0 ]]; then
        echo "Not found"
        return
    fi
    fzf --help >& /dev/null
    if [ $? == 0 ];then
        CD_P=$(cat $FILELIST | grep "$1" | fzf +m)
        if [[ -z $CD_P ]]; then
            echo "no select file"
            return
        fi
        if [[ -z $2 ]]; then
            #cd ${CD_P%/*}
            local cd_name=$(dirname $CD_P)
            cd $cd_name
        else
            vim $CD_P
        fi
    else
        local pathname
        local choice
        if [[ ${#lines[@]} > 1 ]]; then
            while [[ -z "$pathname" ]]; do
                local index=1
                local line
                for line in ${lines[@]}; do
                    printf "%6s %s\n" "[$index]" $line
                    index=$(($index + 1))
                done
                echo
                echo -n "Select one: "
                unset choice
                read choice
                if [[ $choice -gt ${#lines[@]} || $choice -lt 1 ]]; then
                    echo "Invalid choice"
                    continue
                fi
                pathname=${lines[$(($choice-1))]}
            done
        else
            pathname=${lines[0]}
        fi
        \cd $pathname
    fi
}
