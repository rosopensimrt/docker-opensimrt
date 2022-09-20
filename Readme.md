# docker opensimrt

This repository contains scripts for building and launching OpenSimRT with a ROS interface. It was based on the [CI yaml from OpenSimRT. ](https://github.com/mitkof6/OpenSimRT). It was meant to be used on Linux, however it may be possible to use other Docker for Windows or Mac, however those cases have not been thoroughly tested.

To use it you need to have [docker installed](https://docs.docker.com/get-docker/).

Build with :

    $ bash build_docker_image.sh

Run with:

    $ bash run_docker_image.sh
    
# Structure

The code was devided into 2 different workspaces to reduce compilation times so opensimrt_core can be compiled during the build script and the main catkin workspace can be compiled at runtime. This allowed us to share catkin\_ws as a docker volume and make sure that code changes are not lost between multiple sessions.

# Usage

ATTENTION: Currently the docker's catkin\_ws generation is not up-to-date with the version used on the paper (the repository ownerships have changed and it needs updating) and the demonstration scripts are being changed to make sure everything works as intended.

The demos are tmux sessions which load roscore and the necessary roslaunch files. Tmux was used to allow for easier debug. Neovim is also available for editing source code with YouCompleteMe installed for code completion. 

First source the workspace:
    
    $ source /catkin_ws/devel/setup.bash
    
And execute the launcher script:

    $ rosrun osrt_ros tmux_session_XXX
    
Where XXX is the particular demo.

# Using AR

Your camera needs to be calibrated and the fiducials need to be printed. More details in https://github.com/mysablehats/ar_test

# XIMU port forwarding

To use XIMU3 sensors with WiFi, docker needs to be able to access the appropriate ports. Those need to be setup correctly in the "run\_docker\_image.sh" script and possibly in the ros.Dockerfile.

# Docker builds

If instead you just want to use the already built docker image, you can get them [here](https://hub.docker.com/r/mysablehats/opensim-rt/tags). We are not freezing versions, so it is possible that the builder script will break in the future. 

The docker with the default version from mitkof6/OpenSIMRT can be obtained with: 

     docker pull mysablehats/opensim-rt:main

It can also be directly accessed [here](https://hub.docker.com/layers/mysablehats/opensim-rt/main/images/sha256-f3f238759e736f2fd01b9a1eec307b9dbe664f97206e438541bb2685b9fcb38e).

# Windows and Mac users

Currently the visualizations (either from rViz or from OpenSim) are using X, so to be able to see visual output you will need an X server. Docker networking with ROS can be tricky and we provide no support for those cases. If you know what you are doing, you can forward the topics to another Linux PC with ROS natively installed or even do your own visualization using the ROS implementation under the hood (say with an additional node serving as a tunnel). 

## Windows Users:

To show graphics make sure you have either Xming or vcxsrv installed and running. 

Xming and vcxsrv will be running on the WSL ip address of your computer. You can check this IP by either opening a CMD (windows key + R then type cmd, in command prompt type ipconfig and use the IP from WSL) or by checking the log file from xming/ vcxsrv.

This ip will be used to set the DISPLAY variable which will run inside the docker as

    $ export DISPLAY=172.23.64.1:0.0

Or whatever your ip is. 

## Mac

The X server for MacOS is XQuartz. It may have the same limitations as Windows visualization, but this has not been tested.

## Known issues

Showing OpenSim graphics in Linux uses X forwarding with hardware acceleration. This is not available in Windows (as far as I know) and may the reason why running the Docker inside Windows has such slow performance.
