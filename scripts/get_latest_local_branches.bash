cd /catkin_opensim/src/opensimrt_core
git pull local slim-devel && \
git checkout local/slim-devel 
cd /catkin_opensim/src/opensimrt_bridge
git pull local feature/unified-conversions && \
git checkout local/feature/unified-conversions
cd /catkin_opensim/src/opensimrt_msgs
git pull local events && git pull local feature/dual-messages &&\
git checkout local/feature/dual-messages
#git checkout local/devel
cd /catkin_opensim/
rm -rf build devel && catkin_build_opensimrt.bash

