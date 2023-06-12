git config --global user.email "frekle@kth.se" && \
git config --global user.name "frekle"

cd /catkin_opensim/src/opensimrt_core
git remote add local /catkin_ws/OpenSimRT.git 
cd /catkin_opensim/src/opensimrt_bridge
git remote add local /catkin_ws/opensimrt_bridge.git 
cd /catkin_opensim/src/opensimrt_msgs
git remote add local /catkin_ws/opensimrt_msgs.git
