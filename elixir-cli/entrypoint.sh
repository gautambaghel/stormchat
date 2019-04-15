#!/bin/sh

set -e

sh -c "mix local.hex --force"
sh -c "mix $*"
