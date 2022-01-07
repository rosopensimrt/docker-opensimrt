FROM ubuntu:18.04

RUN apt-get update && apt-get install freeglut3-dev git libxi-dev libxmu-dev liblapack-dev doxygen cmake wget xz-utils --yes
#RUN apt-get install wget xz-utils --yes
WORKDIR /opensimrt
RUN git clone https://github.com/mitkof6/OpenSimRT.git /opensimrt

WORKDIR dependencies
RUN wget https://sourceforge.net/projects/dependencies/files/opensim-core/opensim-core-4.1-ubuntu-18.04.tar.xz && \
        tar -xvf opensim-core-4.1-ubuntu-18.04.tar.xz 

RUN  wget https://sourceforge.net/projects/dependencies/files/oscpack/oscpack-ubuntu-18.04.tar.xz && \
        tar -xvf oscpack-ubuntu-18.04.tar.xz  

RUN  wget https://sourceforge.net/projects/dependencies/files/vicon/ViconDataStreamSDK_1.7.1_96542h.tar.xz && \
        tar -xvf ViconDataStreamSDK_1.7.1_96542h.tar.xz

#RUN apt-get install git --yes
WORKDIR ../build

RUN apt-get install build-essential --yes
RUN sed 's@~@/opensimrt@' /opensimrt/.github/workflows/env_variables >> /opensimrt/env.sh
RUN . /opensimrt/env.sh && cmake ../ \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_INSTALL_PREFIX:PATH=../install \
            -DOpenSim_DIR=$OpenSim_DIR \
            -DCONTINUOUS_INTEGRATION=ON \
            -DBUILD_TESTING=ON \
            -DBUILD_DOCUMENTATION=OFF \
            -DDOXYGEN_USE_MATHJAX=ON \
            -DBUILD_MOMENT_ARM=ON \
            -DBUILD_IMU=ON \
            -DBUILD_VICON=ON \
            -DCMAKE_PREFIX_PATH=$OpenSim_DIR:$OSCPACK_DIR/lib:$VICONDATASTREAM_DIR && \
        make -j$(nproc)
