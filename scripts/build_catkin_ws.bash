#!/usr/bin/env bash
source /catkin_opensim/devel/setup.bash
export OPENSIM_HOME=/opt/dependencies/opensim-core
export OpenSim_DIR=/opt/dependencies/opensim-core/lib/cmake/OpenSim
cd /catkin_ws 
catkin_make "$@"
source /catkin_ws/devel/setup.bash
echo "source /catkin_ws/src/tmux_launch/scripts/register_tmux.bash" >> /catkin_ws/devel/setup.bash
