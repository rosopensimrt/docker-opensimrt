FROM ros:noetic-ros-base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install build-essential freeglut3-dev git libxi-dev libxmu-dev liblapack-dev doxygen cmake wget xz-utils vim python ros-noetic-desktop-full v4l-utils catkin-lint --yes && rm -rf /var/lib/apt/lists/*
WORKDIR /opt/dependencies

RUN wget https://sourceforge.net/projects/dependencies/files/opensim-core/opensim-core-4.1-ubuntu-18.04.tar.xz && \
        tar -xvf opensim-core-4.1-ubuntu-18.04.tar.xz && rm opensim-core-4.1-ubuntu-18.04.tar.xz 

RUN  wget https://sourceforge.net/projects/dependencies/files/oscpack/oscpack-ubuntu-18.04.tar.xz && \
        tar -xvf oscpack-ubuntu-18.04.tar.xz && rm oscpack-ubuntu-18.04.tar.xz 

RUN  wget https://sourceforge.net/projects/dependencies/files/vicon/ViconDataStreamSDK_1.7.1_96542h.tar.xz && \
        tar -xvf ViconDataStreamSDK_1.7.1_96542h.tar.xz && rm ViconDataStreamSDK_1.7.1_96542h.tar.xz

RUN echo "I use this to make it get stuff from git again"

RUN git clone https://github.com/mysablehats/OpenSimRT_data.git /srv/data

WORKDIR /catkin_opensim/src

ENV OPENSIMRTDIR=opensimrt_core
#RUN echo "I use this to make it get stuff from git again"

RUN git clone https://github.com/frederico-klein/OpenSimRT.git ./$OPENSIMRTDIR -b slim-linted --single-branch && ln -s /srv/data $OPENSIMRTDIR/data  
#RUN git clone https://github.com/frederico-klein/OpenSimRT.git ./opensimrt -b v0.03.1ros --depth 1 && ln -s /srv/data opensimrt/data  
RUN sed 's@~@/opt@' ./$OPENSIMRTDIR/.github/workflows/env_variables >> ./$OPENSIMRTDIR/env.sh

RUN git clone https://github.com/mysablehats/opensimrt_msgs.git -b v0.03ros

RUN git clone https://github.com/mysablehats/opensimrt_bridge.git -b devel

ENV PYTHONPATH=/opt/ros/noetic/lib/python3/dist-packages/:$PYTHONPATH

#RUN mkdir -p /opensimrt/build/devel/ && \
#	ln -s /opt/ros/noetic/share/ /opensimrt/build/devel/share && \
#	ln -s /opt/ros/noetic/include/ /opensimrt/build/devel/include

ENV LD_LIBRARY_PATH=/opt/dependencies/opensim-core/lib/
#:/opensimrt/build/

RUN echo "git pull && git checkout permissions && cd /opensimrt/build && bash build.bash" >> ~/.bash_history
	
EXPOSE 8080/udp

#WORKDIR /opensimrt

#RUN git clone https://github.com/frederico-klein/imu_driver.git -b v0.03ros

#WORKDIR /catkin_opensim/src/opensimrt

#RUN git pull && git checkout permissions 

WORKDIR /catkin_opensim

ADD scripts/build_opensimrt.bash /bin/catkin_build_opensimrt.bash
RUN catkin_build_opensimrt.bash

WORKDIR /

ADD scripts/build_catkin_ws.bash /bin/catkin_build_ws.bash
#this is a volume now so we can't build it at docker build time
#RUN bash build_ws.bash

ADD scripts/entrypoint.sh /bin/entrypoint.sh 
RUN wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && python3 -m pip install --user --upgrade pynvim
ADD .vimrc /root

ENTRYPOINT [ "entrypoint.sh" ]
