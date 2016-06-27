#!/bin/bash
set -e

SELFOSSDATA=/var/lib/selfoss
SELFOSSPROG=/home/selfoss

function setup_selfoss() {
}

trap "shut_down" SIGKILL SIGTERM SIGHUP SIGINT EXIT

/bin/chown selfoss:selfoss ${SELFOSSDATA}

/bin/su - selfoss -c 'php -S 0.0.0.0:8080 -t /home/selfoss'
