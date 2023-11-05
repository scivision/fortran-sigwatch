#!/usr/bin/env bash

[[ $# -eq 0 ]] && echo "Usage: $0 <executable>" && exit 1

$1 &

sleep 1

kill -HUP $!

sleep 1

kill -USR1 $!
