FROM ros:noetic-ros-base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install build-essential freeglut3-dev git libxi-dev libxmu-dev liblapack-dev doxygen gdb cmake wget xz-utils vim python ros-noetic-desktop-full v4l-utils catkin-lint tmux --yes && rm -rf /var/lib/apt/lists/*
WORKDIR /opt/dependencies

RUN wget https://sourceforge.net/projects/dependencies/files/opensim-core/opensim-core-4.1-ubuntu-18.04.tar.xz && \
        tar -xvf opensim-core-4.1-ubuntu-18.04.tar.xz && rm opensim-core-4.1-ubuntu-18.04.tar.xz 

RUN  wget https://sourceforge.net/projects/dependencies/files/oscpack/oscpack-ubuntu-18.04.tar.xz && \
        tar -xvf oscpack-ubuntu-18.04.tar.xz && rm oscpack-ubuntu-18.04.tar.xz 

RUN  wget https://sourceforge.net/projects/dependencies/files/vicon/ViconDataStreamSDK_1.7.1_96542h.tar.xz && \
        tar -xvf ViconDataStreamSDK_1.7.1_96542h.tar.xz && rm ViconDataStreamSDK_1.7.1_96542h.tar.xz

#RUN echo "I use this to make it get stuff from git again"

RUN git clone https://github.com/mysablehats/OpenSimRT_data.git /srv/data

ADD scripts/ximu.bash /bin
RUN /bin/ximu.bash
#this is a volume now so we can't build it at docker build time
#RUN bash catkin_build_ws.bash
RUN echo "reinstall neovim"
RUN wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && python3 -m pip install --upgrade pynvim
ADD vim /nvim
ADD scripts/vim_install.bash /nvim
RUN /nvim/vim_install.bash
ADD tmux/.tmux.conf /etc/tmux


RUN echo "I use this to make it get stuff from git again"

# Set user and group
ARG user=osruser1
ARG group=osruser1
ARG uid=1000
ARG gid=1000
#ARG VIDEOGROUP=${VIDEOGROUP}
#RUN groupadd -g $VIDEOGROUP video
RUN groupadd -g ${gid} ${group}
RUN useradd -u ${uid} -g root -G sudo,audio,video,${gid} -s /bin/bash -m ${user} -p123456
# Switch to user
USER ${uid}

WORKDIR /catkin_opensim/src

ENV OPENSIMRTDIR=opensimrt_core
RUN echo "I use this to make it get stuff from git again"

RUN git clone https://github.com/opensimrt-ros/opensimrt_core.git ./$OPENSIMRTDIR -b slim-devel  && ln -s /srv/data $OPENSIMRTDIR/data && echo hello 
#RUN git clone https://github.com/frederico-klein/OpenSimRT.git ./opensimrt -b v0.03.1ros --depth 1 && ln -s /srv/data opensimrt/data  
RUN sed 's@~@/opt@' ./$OPENSIMRTDIR/.github/workflows/env_variables >> ./$OPENSIMRTDIR/env.sh

RUN git clone https://github.com/opensimrt-ros/opensimrt_msgs.git -b devel

RUN git clone https://github.com/opensimrt-ros/opensimrt_bridge.git -b devel-insoles

ENV PYTHONPATH=/opt/ros/noetic/lib/python3/dist-packages/:$PYTHONPATH

#RUN mkdir -p /opensimrt/build/devel/ && \
#	ln -s /opt/ros/noetic/share/ /opensimrt/build/devel/share && \
#	ln -s /opt/ros/noetic/include/ /opensimrt/build/devel/include

ENV LD_LIBRARY_PATH=/opt/dependencies/opensim-core/lib/
#:/opensimrt/build/

#RUN echo "git pull && git checkout permissions && cd /opensimrt/build && bash build.bash" >> ~/.bash_history
#RUN printf 'export PATH=/nvim/:/root/tmux:$PATH\n' >> ~/.bashrc
	
#WORKDIR /opensimrt

#RUN git clone https://github.com/frederico-klein/imu_driver.git -b v0.03ros

#WORKDIR /catkin_opensim/src/opensimrt

#RUN git pull && git checkout permissions 
ENV HOME_DIR=/home/${user}
ADD scripts/vim_configure.bash ${HOME_DIR}/
RUN ~/vim_configure.bash

ADD tmux/.tmux.conf ${HOME_DIR}/

ADD scripts/build_opensimrt.bash /bin/catkin_build_opensimrt.bash

ADD scripts/build_catkin_ws.bash /bin/catkin_build_ws.bash

RUN echo "source /catkin_opensim/devel/setup.bash" >> ~/.bash_history

RUN /bin/catkin_build_opensimrt.bash

#EXPOSE 8080/udp

EXPOSE 9000/udp
EXPOSE 9001/udp
EXPOSE 10000/udp

EXPOSE 8001/udp
EXPOSE 8000/udp

expose 7000/tcp

##BLING
ADD scripts/bash_git.bash ${HOME_DIR}/.bash_git
ADD scripts/bashbar.bash  ${HOME_DIR}/.bash_bar
RUN echo "source ~/.bash_git" >> ~/.bashrc && \
    echo "source ~/.bash_bar" >> ~/.bashrc

ADD scripts/create_bashrcs.bash ${HOME_DIR}/.create_bashrcs.sh
#ADD tmux/ /usr/local/bin # moved to a volume

ADD scripts/catkin.sh /bin/first_time_catkin_builder.sh
#USER root
WORKDIR /opt/dependencies/opensim-core/lib/python3.6/site-packages/
USER root

RUN python3.8 setup.py install
WORKDIR /usr/lib/x86_64-linux-gnu
RUN apt-get install libpython-all-dev libeigen3-dev -y
RUN ln -s libpython3.8.so.1.0 libpython3.6m.so.1.0
RUN apt-get install iputils-ping alsa-utils pulseaudio libasound2 libasound2-plugins -y
USER ${uid}
RUN echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/dependencies/opensim-core/lib' >> ~/.bashrc
RUN bash ~/.create_bashrcs.sh

RUN pip3 install --upgrade pip && hash -r && pip3 install --upgrade pip && pip3 install protobuf==3.20.1

#port for insoles
EXPOSE 9999

ADD scripts/insoles.bash /bin/insoles.bash
WORKDIR /catkin_ws
ADD scripts/entrypoint.sh /bin/entrypoint.sh 
## dynamic reconfigure has problems with newer versions of pyyaml
## also need pupil and nest for eye_tracker
RUN pip install PyYAML==5.3 mock numpy pupil-labs-realtime-api nest_asyncio
USER root
ADD scripts/configure_sound.bash /tmp/conf_alsa.bash
RUN /tmp/conf_alsa.bash
#RUN apt remove python -y
USER 1000
RUN rosdep update
#RUN apt install cowsay -y
#EXPOSE 8080/tcp
ENTRYPOINT [ "entrypoint.sh" ]
