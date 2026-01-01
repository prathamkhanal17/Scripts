#!/bin/bash

file_name=${1:-""}
file_name=${file_name##*/}

command -v tsc >/dev/null || { echo "tsc not found"; exit 1;}
command -v node >/dev/null || { echo "tsc not found"; exit 1;}

if [[ "$file_name" == *.ts ]]; then
    echo "Compiling $file_name to ${file_name%.ts}.js..."
    tsc $file_name
    tmp_name=${file_name%.ts}
    echo "Running $tmp_name.js..."
    node $tmp_name.js
    echo "Cleaning up..."
    rm $tmp_name.js
else
    echo "this is not  a typescript file"
fi
