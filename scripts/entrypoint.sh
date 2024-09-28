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

## I should get this from options//
DOCKER_USER_NAME=rosopensimrt

export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR
gosu $DOCKER_USER_NAME:$DOCKER_USER_NAME dbus-daemon --session --address=$DBUS_SESSION_BUS_ADDRESS --nofork --nopidfile --syslog-only &
#dbus-daemon --session --address=$DBUS_SESSION_BUS_ADDRESS --nofork --nopidfile --syslog-only &

# inspired by: https://github.com/redis/docker-library-redis/blob/master/Dockerfile.template& https://github.com/redis/docker-library-redis/blob/master/docker-entrypoint.sh

#maybe we can use just the second one for docker --user ?

#usermod -u ${OUTSIDEY_USER_ID} $DOCKER_USER_NAME

ACTUAL_USER_ID=$OUTSIDEY_USER_ID
if [ "$IS_ROOTLESS" = "true" ]; then
	OUTSIDEY_USER_ID=root
fi

cleanup()
{
	echo "attempting cleanup"
	chown -R $OUTSIDEY_USER_ID:$OUTSIDEY_USER_ID /srv/host_data
	chown -R $OUTSIDEY_USER_ID:$OUTSIDEY_USER_ID /catkin_ws
	echo "permissions reset to $ACTUAL_USER_ID! "
}

trap "cleanup" INT EXIT

chown -R $DOCKER_USER_NAME:$DOCKER_USER_NAME /srv/host_data
chown -R $DOCKER_USER_NAME:$DOCKER_USER_NAME /catkin_ws

## Running passed command
if [[ "$1" ]]; then
	gosu $DOCKER_USER_NAME "$@"
fi


