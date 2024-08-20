#!/usr/bin/env bash
source /catkin_opensim/devel/setup.bash
export OPENSIM_HOME=/opt/dependencies/opensim-core
export OpenSim_DIR=/opt/dependencies/opensim-core/lib/cmake/OpenSim

mkdir -p /catkin_ws/src

cd /catkin_ws/src

git clone https://github.com/machinekoder/ar_track_alvar.git -b noetic-devel

git clone https://github.com/ros-drivers/usb_cam.git
git clone https://github.com/CCNYRoboticsLab/imu_tools
git clone https://github.com/opensimrt-ros/osrt_ros.git
git clone https://github.com/opensimrt-ros/gait1992_description.git
git clone https://github.com/opensimrt-ros/cometa_bridge.git -b devel
git clone https://github.com/opensimrt-ros/ar_test.git -b fixing_cube 
git clone https://github.com/opensimrt-ros/opensimrt_msgs.git

cd ..
catkin_make
