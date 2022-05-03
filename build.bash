source src/opensimrt/env.sh 
. /opt/ros/noetic/setup.sh
catkin_make  \
            -DCMAKE_BUILD_TYPE=Release \
            -DOpenSim_DIR=$OpenSim_DIR \
            -DCONTINUOUS_INTEGRATION=OFF \
            -DBUILD_TESTING=ON \
            -DBUILD_DOCUMENTATION=OFF \
            -DDOXYGEN_USE_MATHJAX=OFF \
            -DBUILD_MOMENT_ARM=ON \
            -DBUILD_IMU=OFF \
            -DBUILD_UIMU=ON \
            -DBUILD_VICON=ON 
#            -DCMAKE_PREFIX_PATH=/opt/ros/noetic:$OpenSim_DIR:$OSCPACK_DIR/lib:$VICONDATASTREAM_DIR

