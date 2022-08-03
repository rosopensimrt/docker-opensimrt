#!/usr/bin/env bash
set -e

source /opt/ros/$ROS_DISTRO/setup.bash
#catkin_build_ws.bash

export OPENSIMRTDIR=opensimrt_core

## Running passed command
if [[ "$1" ]]; then
	eval "$@"
fi

