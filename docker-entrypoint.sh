#!/bin/bash
set -e

SELFOSSDATA=/var/lib/selfoss
SELFOSSPROG=/home/selfoss

function setup_selfoss() {
    /bin/mv ${SELFOSSPROG}/data ${SELFOSSDATA}/
    /bin/ln -s ${SELFOSSDATA}/data ${SELFOSSPROG}/
    /bin/mv ${SELFOSSPROG}/public ${SELFOSSDATA}/
    /bin/ln -s ${SELFOSSDATA}/public ${SELFOSSPROG}/
}

function update_selfoss() {
    /bin/rm -rf ${SELFOSSPROG}/data
    /bin/ln -s ${SELFOSSDATA}/data ${SELFOSSPROG}/
    /bin/rm -rf ${SELFOSSPROG}/public
    /bin/ln -s ${SELFOSSDATA}/public ${SELFOSSPROG}/
    /bin/rm -f ${SELFOSSPROG}/public/all*
}

function config_selfoss() {
    /bin/sed -i 's/^logger_level=.*$/logger_level=DEBUG/' ${SELFOSSPROG}/defaults.ini
    /bin/sed -i 's/^homepage=.*$/homepage=unread/' ${SELFOSSPROG}/defaults.ini
}
#trap "shut_down" SIGKILL SIGTERM SIGHUP SIGINT EXIT

/bin/chown selfoss:selfoss ${SELFOSSDATA}

if [ ! -f ${SELFOSSDATA}/data/sqlite/selfoss.db ]
then
    echo "* Setting up SelfOSS"
    setup_selfoss
else
    echo "* Updating SelfOSS"
    update_selfoss
fi
echo "** Configuring SelfOSS"
config_selfoss

/bin/su - selfoss -c "TERM=xterm /usr/bin/php -S 0.0.0.0:8080 -t ${SELFOSSPROG} ${SELFOSSPROG}/run.php"
