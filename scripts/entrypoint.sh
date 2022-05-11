#!/usr/bin/env bash
set -e

source /opt/ros/noetic/setup.bash
roscore &
#cd build
# if we dont wait, ros often tries to spawn another server and things dont work out
sleep 2 
bash /build_ws.bash
cd /catkin_ws 
if [[ -f "/catkin_ws/devel/setup.bashh" ]]; then
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

