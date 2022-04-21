BRANCH=$(git branch --show-current )
mkdir -p ros/devel
mkdir -p ros/build

if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform        
	docker run --rm -it \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--device=/dev/dri:/dev/dri \
		mysablehats/opensim-rt:$BRANCH
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
	xhost +
	docker run --rm -it -p 8080:8080/udp \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--device=/dev/dri:/dev/dri \
		--device=/dev/video0:/dev/video0 \
		-v $(pwd)/ros:/catkin_ws \
		mysablehats/opensim-rt:$BRANCH /bin/bash
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Do something under 32 bits Windows NT platform
	docker run --rm -it \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--device=/dev/dri:/dev/dri \
		mysablehats/opensim-rt:$BRANCH
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    # Do something under 64 bits Windows NT platform
	winpty docker run --rm -it -p 8080:8080/udp \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		mysablehats/opensim-rt:$BRANCH


fi



