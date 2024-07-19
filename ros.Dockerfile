FROM ros:noetic-ros-base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install \
	build-essential \
	curl \
	freeglut3-dev \
	git \
	libxi-dev \
	libxmu-dev \
	liblapack-dev \
	doxygen \
	gdb \
	cmake \
	wget \
	xz-utils \
	vim \
	python \
	ros-noetic-desktop-full \
	ros-noetic-rosdoc-lite \
	ros-noetic-moveit \
	v4l-utils \
	catkin-lint \
	iputils-ping \
	alsa-utils \
	pulseaudio \
	libasound2 \
	libasound2-plugins \
	libpython-all-dev \
	libeigen3-dev\
	libudev-dev\
	libudev1\
	tmux \
	--yes && rm -rf /var/lib/apt/lists/*
ADD scripts/configure_sound.bash /tmp/conf_alsa.bash
RUN /tmp/conf_alsa.bash

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

## dynamic reconfigure has problems with newer versions of pyyaml
## also need pupil and nest for eye_tracker
RUN wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && python3 -m pip install --upgrade pynvim && \
	pip3 install --upgrade pip && hash -r && pip3 install --upgrade pip && pip3 install protobuf==3.20.1 mock numpy pupil-labs-realtime-api nest_asyncio && \
	pip3 install --ignore-installed PyYAML==5.3 

RUN echo "reinstall neovim"
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
RUN useradd -u ${uid} -g ${gid} -G sudo,audio,video,root -s /bin/bash -m ${user} && echo "${user}:${user}" | chpasswd 
# Switch to user
USER ${uid}

ENV XDG_RUNTIME_DIR=/run/user/"${uid}"

WORKDIR /catkin_opensim/src


ENV OPENSIMRTDIR=opensimrt_core

#half way into removing those hardcoded paths. still hardcoded, but a bit better
ADD cmake/Findsimbody.cmake /opt/dependencies
ADD cmake/FindOpenSim.cmake /opt/dependencies

RUN git clone https://github.com/opensimrt-ros/opensimrt_core.git ./$OPENSIMRTDIR -b slim-devel  && ln -s /srv/data $OPENSIMRTDIR/data  && echo "pulling opensimrt_core again"  
#RUN git clone https://github.com/frederico-klein/OpenSimRT.git ./opensimrt -b v0.03.1ros --depth 1 && ln -s /srv/data opensimrt/data  
RUN sed 's@~@/opt@' ./$OPENSIMRTDIR/.github/workflows/env_variables >> ./$OPENSIMRTDIR/env.sh

RUN git clone https://github.com/opensimrt-ros/opensimrt_msgs.git -b devel && echo "pulling opensimrt_msgs again"
#RUN echo "I use this to make it get stuff from git again"

RUN git clone https://github.com/opensimrt-ros/opensimrt_bridge.git -b devel && echo "pulling opensimrt_bridge again"

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
USER root
#I dont think this variable is set yet
WORKDIR /opt/dependencies/opensim-core/lib/python3.6/site-packages/
RUN python3.8 setup.py install
WORKDIR /usr/lib/x86_64-linux-gnu
RUN ln -s libpython3.8.so.1.0 libpython3.6m.so.1.0
## fixing bug in view_frames
RUN sed -i "s/\(subprocess.Popen([^)]*\)/\1,universal_newlines=True/" /opt/ros/noetic/lib/tf/view_frames 

ADD scripts/realsense_install.bash /usr/sbin/
RUN bash /usr/sbin/realsense_install.bash

RUN mkdir -p -m 0700 /var/run/dbus && chown ${gid}:${uid} /var/run/dbus

USER ${uid}
RUN echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/dependencies/opensim-core/lib' >> ~/.bashrc

ENV HOME_DIR=/home/${user}
ADD scripts/vim_configure.bash ${HOME_DIR}/
RUN ~/vim_configure.bash

ADD tmux/.tmux.conf ${HOME_DIR}/

ADD scripts/build_opensimrt.bash /bin/catkin_build_opensimrt.bash

ADD scripts/build_catkin_ws.bash /bin/catkin_build_ws.bash

RUN printf "source /catkin_ws/devel/setup.bash\nsource /catkin_opensim/devel/setup.bash" >> ~/.bash_history

RUN /bin/catkin_build_opensimrt.bash

#EXPOSE 8080/udp
#EXPOSE 8080/tcp

EXPOSE 9000/udp
EXPOSE 9001/udp
EXPOSE 10000/udp

EXPOSE 8001/udp
EXPOSE 8000/udp

EXPOSE 7000/tcp
#port for insoles
EXPOSE 9999

##BLING
ADD scripts/bash_git.bash ${HOME_DIR}/.bash_git
ADD scripts/bashbar.bash  ${HOME_DIR}/.bash_bar
RUN echo "source ~/.bash_git" >> ~/.bashrc && \
    echo "source ~/.bash_bar" >> ~/.bashrc && \
    echo "export EDITOR='nv'" >> ~/.bashrc


ADD scripts/create_bashrcs.bash ${HOME_DIR}/.create_bashrcs.sh
RUN bash ~/.create_bashrcs.sh
#ADD tmux/ /usr/local/bin # moved to a volume

ADD scripts/catkin.sh /bin/first_time_catkin_builder.sh

## gets latest local environment
ADD scripts/set_local_branches.bash /bin/set_local_branches.bash
#ADD scripts/get_latest_local_branches.bash /bin/get_latest_local_branches.bash
ADD scripts/entrypoint.sh /bin/entrypoint.sh 
#RUN apt remove python -y
#RUN apt install cowsay -y

RUN rosdep update
RUN pip3 install timeout_decorator libtmux sympy tqdm

WORKDIR ~
RUN git clone https://github.com/mrocklin/multipolyfit.git \
	&& cd multipolyfit \
	&& pip3 install -e .

WORKDIR /catkin_ws

ENTRYPOINT [ "entrypoint.sh" ]
