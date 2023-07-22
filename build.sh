#!/bin/bash

PLUGIN_NAME="player-session"

cd scripting
spcomp $PLUGIN_NAME.sp -o ../plugins/$PLUGIN_NAME.smx
