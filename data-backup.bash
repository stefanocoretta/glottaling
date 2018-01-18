#!/bin/bash

## Push test

rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/glottaling/data/ \
    /Volumes/Multimedia/ling-data-backup/glottaling/data/

## Push run

rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    ~/GitHub/glottaling/data/ \
    /Volumes/Multimedia/ling-data-backup/glottaling/data/

## Pull test

rsync -anv --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/ling-data-backup/glottaling/data/ \
    ~/GitHub/glottaling/data/

## Pull run

rsync -avz --no-whole-file --delete --exclude '*.DS_Store' \
    /Volumes/Multimedia/ling-data-backup/glottaling/data/ \
    ~/GitHub/glottaling/data/
