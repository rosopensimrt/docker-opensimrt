git config --global user.email "frekle@kth.se" && \
git config --global user.name "frekle"

cd /catkin_opensim/src/opensimrt_core
git remote add local /catkin_ws/OpenSimRT.git && \
git pull local slim-devel && \
git checkout local/slim-devel 
cd /catkin_opensim/src/opensimrt_bridge
git remote add local /catkin_ws/opensimrt_bridge.git && \
git pull local devel-insoles && \
git checkout local/devel-insoles
cd /catkin_opensim/src/opensimrt_msgs
git remote add local /catkin_ws/opensimrt_msgs.git && \
git pull local devel && \
git checkout local/devel
cd /catkin_opensim/
rm -rf build devel && catkin_build_opensimrt.bash

