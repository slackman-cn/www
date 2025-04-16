#!/usr/bin/env bash
#
# Usage: source log.sh
#        LOG date -R
# 
# Usage: source log.sh
#        LOG_PATH=aaa.log
#        LOG date -R

export LOG_PATH
exec 3<&2

# Lazyload
function log_init() {
    if [ -z $LOG_PATH ] ;then
        LOG_PATH=$(mktemp tmp$(date "+%Y%m%d").XXXX.log)
        exec 4<> "$LOG_PATH"
        log_head
    fi

    if [ ! -e $LOG_PATH ] ;then
        touch $LOG_PATH
        exec 4<> "$LOG_PATH"
        log_head
    fi
}

function log_head() {
    local sep="==========================================="
    local line1="Shell name : $(basename $0)"
    local line2="Time Zone  : $(date +%z)"
    local line3="Start time : $(date +%FT%T)"
    printf "%s\n" $sep "$line1" "$line2" "$line3" $sep  >&4
}

function log_command() {
  local arg
  for arg; do
    [ "${#TMPDIR}" -le 1 ] || arg="${arg//$TMP\//\$TMPDIR/}"
    [ "${#HOME}" -le 1 ] || arg="${arg//$HOME\//\$HOME/}"
    case "$arg" in
    *\'* | *\$* )
      printf ' "%s"' "$arg" ;;
    *' '* )
      printf " '%s'" "$arg" ;;
    * )
      printf ' %s' "$arg" ;;
    esac
  done
  printf '\n'
}

# Redirect all subcommand output to LOG_PATH
function LOG() {
    log_init
    local msg="[$(date +%T.%3N)]->$(log_command "$@")"
    printf "\e[%sm%s\e[m" 36 "$msg"
    echo

    printf "%s\n" "$msg" >&4
    local cmd_stdout=4
    local cmd_stderr=4
    local status=0
    # shellcheck disable=SC2261
    "$@" 2>&$cmd_stderr >&$cmd_stdout || status="$?"
    if [ "$status" -ne 0 ]; then
        echo "external command failed with status $status" >&4
    fi
    return "$status"
}
