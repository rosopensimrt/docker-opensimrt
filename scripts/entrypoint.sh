#!/usr/bin/env bash
set -e

source /opt/ros/$ROS_DISTRO/setup.bash
#get_latest_local_branches.bash
#catkin_build_ws.bash
export PATH=/usr/local/bin/tmux_session:$PATH
export OPENSIMRTDIR=opensimrt_core

## check if XDG_RUNTIME_DIR exists and it is writable

if [[ -d "$XDG_RUNTIME_DIR" && -w "$XDG_RUNTIME_DIR" ]]; then
	echo "ok"
else
	#export XDG_RUNTIME_DIR=/tmp/`whoami`
	export XDG_RUNTIME_DIR=/var/run/dbus
	#mkdir -p $XDG_RUNTIME_DIR
fi

export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR
dbus-daemon --session --address=$DBUS_SESSION_BUS_ADDRESS --nofork --nopidfile --syslog-only &

## Running passed command
if [[ "$1" ]]; then
	eval "$@"
fi

