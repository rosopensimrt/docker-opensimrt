FROM ros:noetic-ros-base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install build-essential freeglut3-dev git libxi-dev libxmu-dev liblapack-dev doxygen cmake wget xz-utils vim python ros-noetic-desktop-full v4l-utils --yes && rm -rf /var/lib/apt/lists/*
WORKDIR /opt/dependencies

RUN wget https://sourceforge.net/projects/dependencies/files/opensim-core/opensim-core-4.1-ubuntu-18.04.tar.xz && \
        tar -xvf opensim-core-4.1-ubuntu-18.04.tar.xz 

RUN  wget https://sourceforge.net/projects/dependencies/files/oscpack/oscpack-ubuntu-18.04.tar.xz && \
        tar -xvf oscpack-ubuntu-18.04.tar.xz  

RUN  wget https://sourceforge.net/projects/dependencies/files/vicon/ViconDataStreamSDK_1.7.1_96542h.tar.xz && \
        tar -xvf ViconDataStreamSDK_1.7.1_96542h.tar.xz

WORKDIR /catkin_opensim/src

RUN git clone https://github.com/frederico-klein/OpenSimRT.git ./opensimrt -b permissions 
RUN sed 's@~@/opt@' ./opensimrt/.github/workflows/env_variables >> ./opensimrt/env.sh

ENV PYTHONPATH=/opt/ros/noetic/lib/python3/dist-packages/:$PYTHONPATH

#RUN mkdir -p /opensimrt/build/devel/ && \
#	ln -s /opt/ros/noetic/share/ /opensimrt/build/devel/share && \
#	ln -s /opt/ros/noetic/include/ /opensimrt/build/devel/include

ENV LD_LIBRARY_PATH=/opt/dependencies/opensim-core/lib/
#:/opensimrt/build/

RUN echo "git pull && git checkout permissions && cd /opensimrt/build && bash build.bash" >> ~/.bash_history
	
EXPOSE 8080/udp

WORKDIR /opensimrt

RUN git clone https://github.com/frederico-klein/imu_driver.git 

ADD entrypoint.sh /bin/entrypoint.sh 

WORKDIR /catkin_opensim/src/opensimrt

#RUN git pull && git checkout permissions 

WORKDIR /catkin_opensim

ADD build.bash /catkin_opensim
RUN bash ./build.bash


ENTRYPOINT [ "entrypoint.sh" ]
