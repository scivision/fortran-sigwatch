#!/bin/sh

set -o nounset

$1 &

sleep 1

kill -HUP $!

sleep 1

kill -USR1 $!
