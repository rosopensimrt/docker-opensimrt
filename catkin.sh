mkdir -p /catkin_ws/src

cd /catkin_ws/src

git clone https://github.com/machinekoder/ar_track_alvar.git -b noetic-devel

git clone https://github.com/ros-drivers/usb_cam.git

cd ..
catkin_make
