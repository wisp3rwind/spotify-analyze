#!/usr/bin/env bash
set -eux
FILEPATH="$PWD/dump.dylib"
DYLD_INSERT_LIBRARIES=$FILEPATH LD_PRELOAD=$FILEPATH "$@"
