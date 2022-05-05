#!/usr/bin/env bash
set -e

source /opt/ros/noetic/setup.bash
roscore &
#cd build
#bash build.bash
cd ..
if [[ -f "/catkin_ws/devel/setup.bash" ]]; then
 #rviz -d ./_default.rviz &
 rviz -d ./_cam_tf.rviz &
 source /catkin_ws/devel/setup.bash
 roslaunch ar_test ar_cube.launch &
 roslaunch ar_test usb_cal.launch &
fi

## Running passed command
if [[ "$1" ]]; then
	eval "$@"
fi

