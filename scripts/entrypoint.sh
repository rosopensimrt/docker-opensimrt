#!/usr/bin/env bash
set -e

source /opt/ros/$ROS_DISTRO/setup.bash
#get_latest_local_branches.bash
#catkin_build_ws.bash
export PATH=/usr/local/bin/tmux_session:$PATH
export OPENSIMRTDIR=opensimrt_core

## Running passed command
if [[ "$1" ]]; then
	eval "$@"
fi

