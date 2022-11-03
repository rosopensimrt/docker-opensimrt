BRANCH=$(git branch --show-current )
mkdir -p catkin_ws/devel
mkdir -p catkin_ws/build
NAME=opensimrt_ros_

if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform        
	docker run --rm -it \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--name=$NAME \
		--device=/dev/dri:/dev/dri \
		mysablehats/opensim-rt:$BRANCH
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
	xhost +
	#docker run --rm -it --network=host\
	docker run --rm -it \
		-p 9000:9000/udp \
		-p 8001:8001/udp \
		-p 10000:10000/udp \
		-p 9999:9999 \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--name=$NAME \
		--device=/dev/dri:/dev/dri \
		--device=/dev/video0:/dev/video0 \
		-v $(pwd)/catkin_ws:/catkin_ws \
		-v $(pwd)/tmux:/usr/local/bin/tmux_session\
		mysablehats/opensim-rt:$BRANCH /bin/bash
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Do something under 32 bits Windows NT platform
	docker run --rm -it \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--name=$NAME \
		--device=/dev/dri:/dev/dri \
		mysablehats/opensim-rt:$BRANCH
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    # Do something under 64 bits Windows NT platform
	winpty docker run --rm -it -p 8080:8080/udp \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--name=$NAME \
		mysablehats/opensim-rt:$BRANCH


fi



