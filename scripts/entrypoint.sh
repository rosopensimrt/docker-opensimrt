#!/usr/bin/env bash
set -e

source /opt/ros/noetic/setup.bash
catkin_build_ws.bash

## nvim
export OPENSIMRTDIR=opensimrt_core
export PATH=/nvim:$PATH
python3 /root/.vim/plugged/YouCompleteMe/install.py --clangd-completer

## Running passed command
if [[ "$1" ]]; then
	eval "$@"
fi

