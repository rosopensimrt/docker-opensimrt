#!/usr/bin/env bash
source /catkin_opensim/devel/setup.bash
export OPENSIM_HOME=/opt/dependencies/opensim-core
export OpenSim_DIR=/opt/dependencies/opensim-core/lib/cmake/OpenSim
cd /catkin_ws 
catkin_make "$@"

STRING="source /catkin_ws/src/ros-biomech/tmux_launch/scripts/register_tmux.bash" 
if  grep -q "$STRING" "/catkin_ws/devel/setup.bash" ; then
	echo 'tmux already registered' ; 
else
	echo $STRING >> /catkin_ws/devel/setup.bash
fi

source /catkin_ws/devel/setup.bash

