#!/usr/bin/env bash
set -e

source /opt/ros/noetic/setup.bash
roscore &
cd build
bash build.sh
cd ..
#rviz -d ./default.rviz &
rviz -d ./cam_tf.rviz &
source /catkin_ws/devel/setup.bash
roslaunch ar_test test.launch &
roslaunch ar_test usb_cal.launch &

## Running passed command
if [[ "$1" ]]; then
	eval "$@"
fi

