#!/usr/bin/env bash
#
# Usage:  "./main.sh  --along --blong 123 --clong=456 file1 file2"
# getopt -V
#set -ex
set -E
source log.sh

p() {
    SPACE_NUM=$((35 + ${#2} - ${#1}))
    printf "%s %${SPACE_NUM}s\n" "$1" "$2"
}

help() {
    p "-h --help" "List of supported arguments"
    p "-v --version" "Show Version"
    p ""
    p "--along"         "Don't ask"
    p "--blong <token>" "Don't ask"
    p "--clong [token]" "Don't ask"
}

version() {
    local git_revision=$(git rev-parse --short HEAD)
    p "v0.1" "Q1 2025 Git ${git_revision}"
}

#-o或--options选项后面接可接受的短选项，其中-a选项不接参数，-b选项后必须接参数，-c选项的参数为可选的
#-l或--long选项后面接可接受的长选项，用逗号分开，冒号的意义同短选项。
# ARGS=$(getopt -o ab:c:: --long along,blong:,clong::  -n 'example.sh'  -- "$@")
# if [[ $? -ne 0 ]]; then
#     echo "Terminating..."
#     exit 1
# fi

PARAMETERS='along,blong:,clong::'

if ! OPTS=$(getopt -o "hv" -l "help,version,$PARAMETERS" -n 'main.sh' -- "$@"); then
    help
    exit 1
fi

#将规范化后的命令行参数分配至位置参数（$1,$2,...)
eval set -- "${OPTS}"
 
while true
do
    case "$1" in
        -v|--version)
            version
            exit 0
            ;;
        -h|--help)
            help
            exit 0
            ;;
        --along)
            echo "Option a";
            shift
            ;;
        --blong)
            echo "Option b, argument $2";
            shift 2
            ;;
        --clong)
            case "$2" in
                "")
                    echo "Option c, no argument";
                    shift 2 
                    ;;
                *)
                    echo "Option c, argument $2";
                    shift 2;
                    ;;
            esac
            ;;
        --)
            shift
            break
            ;;
        *)
            help
            echo "Internal error!"
            exit 1
            ;;
    esac
done
 
#处理剩余的参数
for arg in $@
do
    echo "processing $arg"
done



LOG date -R
LOG date -R