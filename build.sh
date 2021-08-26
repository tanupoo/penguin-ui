#!/bin/sh

build()
{
    (
        target=$1
        echo "==== Building $target ===="
        cd $target
        if [ ${do_npm_install} -eq 1 ] ; then
            npm install
            patch -N -p 0 -i ../vue-cli.patch
        fi
        if [ ! -d "node_modules" ] ; then
            echo "ERROR: no node modules.  Rerun with the -n option."
            exit 0
        fi
        alias vue=`pwd`/node_modules/@vue/cli/bin/vue.js
        cp -r ../common src/
        npm run build
    )
}

do_npm_install=0
if [ "$1" = "-n" ] ; then
    do_npm_install=1
    shift
fi

case "$1" in
    1) build step1 ;;
    2) build step2 ;;
    *) 
        build step1
        build step2
        ;;
esac
