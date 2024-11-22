#!/bin/bash

dir="${PWD}/univer-server"

clean_volumn=""
if [ "$1" == "clean" ]; then
    clean_volumn="--volumes"
fi

cd $dir \
    && docker compose down $clean_volumn \
    && cd - \
    && rm -rf $dir