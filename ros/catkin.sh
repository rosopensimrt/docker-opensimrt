. /opt/ros/noetic/setup.sh

mkdir -p /catkin_ws/src

cd /catkin_ws/src

git clone https://github.com/machinekoder/ar_track_alvar.git -b noetic-devel

git clone https://github.com/ros-drivers/usb_cam.git

git clone https://github.com/mysablehats/ar_test.git 

git clone https://github.com/CCNYRoboticsLab/imu_tools

git clone https://github.com/mysablehats/cometa_bridge.git

cd ..
catkin_make
