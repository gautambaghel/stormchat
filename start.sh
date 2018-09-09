#!/bin/bash

export PORT=5100

cd ~/www/stormchat
./bin/stormchat stop || true
./bin/stormchat start
