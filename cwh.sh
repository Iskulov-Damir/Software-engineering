#!/bin/bash

copy_without_hierarchy() {
    for name in `ls $1`; do
        if [[ -d $1/$name ]]; then
            copy_without_hierarchy $1/$name $2
        elif [[ ! -e $2/$name ]]; then
            cp $1/$name $2
        else
            title=$(echo $name | cut -d. -f1)
            extensions=$(echo $name | cut -c $((${#title} + 1))-${#name})
            index=1
            while [[ -e $2/$title-$index$extensions ]]; do
                ((index++))
            done
            cp $1/$name $2/$title-$index$extensions
        fi
    done
}

if [[ $# -ne 2 ]]; then
    echo "Error: Two parameters must be passed"
    exit 1
elif [[ ! -d $1 || ! -d $2 ]]; then
    echo "Error: The parameters must be directories"
    exit 2
else
    copy_without_hierarchy $1 $2
fi
