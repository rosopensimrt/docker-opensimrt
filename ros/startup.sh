#

#roscore &
rviz ./default.rviz &
source /catkin_ws/devel/setup.bash
roslaunch ar_test test.launch &
roslaunch ar_test usb_cal.launch &

