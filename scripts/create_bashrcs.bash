#!/usr/bin/env bash

cp ~/.bashrc ~/.bashrc_opensim.sh

echo "source /catkin_opensim/devel/setup.bash" >> ~/.bashrc_opensim.sh



cp ~/.bashrc ~/.bashrc_ws.sh

echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc_ws.sh



