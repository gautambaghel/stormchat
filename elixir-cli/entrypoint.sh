#!/bin/sh

set -e

sh -c "[[ -z "$MIX_ENV" ]] && MIX_ENV=$MIX_ENV mix $*"
