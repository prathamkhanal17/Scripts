#!/bin/bash

command -v gcc > /dev/null || { echo "gcc not found!"; exit 1; }

file_name=${1-:''}
file_name=${file_name##*/}
if [ -e "$file_name" ]; then
    {

        if [[ "$file_name" == *.c ]]; then
            {
                echo "Compiling file..."
                gcc "$file_name" -o tmp_bin
                echo "Running file..."
                ./tmp_bin
                rm tmp_bin
            }
        else
            {
                echo "Provided file is not a C file"
            }
        fi
    }
else
    {
        echo "File doesn't exist"
    }
fi
