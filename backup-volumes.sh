#!/bin/bash

# USAGE: ./backup-volumes.sh backup_prefix volume1 volume2...
# Note that a volume name of "bind:x" will bind path x to a volume, relative
# to the current working directory

FILE_PREFIX=$1
VOLUMES=( "${@:2}" )
BACKUPS_DIR="$(pwd)/volume_backups/$FILE_PREFIX"

function sanitize_file_name {
    echo -n $1 | perl -pe 's/[\?\[\]\/\\=<>:;,''"&\$#*()|~`!{}%+]//g;' -pe 's/[\r\n\t -]+/-/g;'
}

for VOLUME in ${VOLUMES[*]}; do
    SHORT_NAME=$VOLUME

    if [[ $VOLUME == bind:* ]] ; then
        REL_PATH=$(echo ${SHORT_NAME:5})

        VOLUME="$(pwd)/$REL_PATH"
        SHORT_NAME=$(sanitize_file_name $REL_PATH)
    fi

    OUTPUT_NAME="$FILE_PREFIX-$SHORT_NAME.tar.gz"


    echo Backing up $VOLUME to $BACKUPS_DIR/$OUTPUT_NAME

    docker run --rm\
        -v $BACKUPS_DIR:/backups\
        -v $VOLUME:/volumes/$SHORT_NAME:ro\
        -w /volumes debian:buster-slim\
        tar -czf /backups/$OUTPUT_NAME $SHORT_NAME
done
