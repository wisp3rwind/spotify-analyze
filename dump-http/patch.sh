#!/usr/bin/env bash
set -eux
FILEPATH="$PWD/curl_patch.dylib"
DYLD_INSERT_LIBRARIES=$FILEPATH LD_PRELOAD=$FILEPATH "$@"
