#!/usr/bin/env bash
set -e

pushd /catkin_ws 
source /catkin_ws/devel/setup.bash

tmux new-session -s ar_session -d bash
tmux send -t ar_session:0.0 "roscore" C-m
sleep 2

tmux new-window
tmux select-window -t 1
tmux split-window -h bash
tmux split-window -h bash
tmux split-window -h bash
tmux select-layout even-horizontal
tmux select-pane -t 3
tmux split-window -v -p 50 bash
tmux select-pane -t 2
tmux split-window -v -p 50 bash
tmux select-pane -t 1 
tmux split-window -v -p 50 bash
tmux select-pane -t 0
tmux split-window -v -p 50 bash
#tmux select-layout tiled
#tmux select-pane -t 0

#sends keys to first and second terminals
tmux send -t ar_session:1.0 "rviz -d ./_cam_tf.rviz" C-m
 #rviz -d ./_default.rviz
tmux send -t ar_session:1.1 "roslaunch ar_test ar_cube.launch" C-m
tmux send -t ar_session:1.2 "roslaunch ar_test usb_cal.launch" C-m
#tmux send -t ar_session:1.3 "rostopic echo /inverse_kinematics_from_file/r_data2" C-m
#tmux send -t ar_session:1.4 "rosservice call /inverse_kinematics_from_file/start" C-m
#tmux send -t ar_session:1.5 "roslaunch opensimrt	id.launch" C-m

#tmux send -t ar_session:1.6 "ls -la" C-m
#tmux send -t ar_session:1.7 "ls -la" C-m
#tmux setw synchronize-panes on

tmux -2 a -t ar_session
popd 
