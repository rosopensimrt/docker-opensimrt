#!/usr/bin/env bash
source /catkin_opensimrt/devel/setup.bash
export OPENSIM_HOME=/opt/dependencies/opensim-core
export OpenSim_DIR=/opt/dependencies/opensim-core/lib/cmake/OpenSim
cd /catkin_ws 
catkin_make
