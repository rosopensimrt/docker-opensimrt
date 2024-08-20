#BRANCH=latest
BRANCH=$(git branch --show-current )
mkdir -p catkin_ws/devel
mkdir -p catkin_ws/build
NAME=${1:-opensimrt_ros_}
CATKIN_WS_DIR=${2:-$(pwd)/catkin_ws}
DOCKER_IMAGE_NAME=rosopensimrt/opensim-rt
#DOCKER_IMAGE_NAME=rosopensimrt/ros
echo -en "\e]0;MAIN WINDOW DO NOT CLOSE!!!! [$CATKIN_WS_DIR]\a"
#!/bin/bash

BUS=$(lsusb | grep 8086 | cut -d " " -f 2)
PORT=$(lsusb | grep 8086 | cut -d " " -f 4 | cut -d ":" -f 1)

if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform        
	docker run --rm -it \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--name=$NAME \
		--device=/dev/dri:/dev/dri \
		$DOCKER_IMAGE_NAME:$BRANCH
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
	USER_UID=$(id -u)
	#let's also run the vm for the android device
	# it doesnt seem to work if the bt dongle is already plugged in, so let's check for that
	VENDOR_DEV=?????0bda:8771
	BT_INSERTED=$(lsusb -d $VENDOR_DEV)
	if [[ $BT_INSERTED ]]; then
		echo "Remove BT device before starting VM..."
		exit 0
	fi
	echo "You can put the dongle after the android vm has started"
	scripts/how_to_start_bt_androidx86_vm.py &

	## slightly better alternative, untested:
	#xhost +
    	xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f /tmp/.docker.xauth nmerge -

	FILES="/dev/video*"
	LINE=""
	for f in $FILES
	do
	  echo "Adding video device $f ..."
	  # take action on each file. $f store current file name
	  LINE="--device=$f:$f $LINE"
	done
	echo $LINE

	#not sure if I need to expose these ports, but it is working
	#docker run --rm -it --network=host\
	docker run --rm -it \
		-p 9000:9000/udp \
		-p 8001:8001/udp \
		-p 10000:10000/udp \
		-p 9999:9999 \
		-p 1030:1030/udp \
		-e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /tmp/.docker.xauth:/tmp/.docker.xauth:rw -e XAUTHORITY=/tmp/.docker.xauth\
		--name=$NAME \
		--device=/dev/snd:/dev/snd \
		--device=/dev/dri:/dev/dri $LINE \
		-v $CATKIN_WS_DIR:/catkin_ws \
		-v $(pwd)/Data:/srv/host_data \
		-v $(pwd)/tmux:/usr/local/bin/tmux_session\
		-v /run/user/${USER_UID}/pulse:/run/user/1000/pulse \
  		--volume /dev/bus/usb/$BUS/$PORT:/dev/bus/usb/$BUS/$PORT \
		-e PULSE_SERVER=unix:/run/user/1000/pulse/native \
		$DOCKER_IMAGE_NAME:$BRANCH /bin/bash -l
		#-u 1000:1000 \
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Do something under 32 bits Windows NT platform
	docker run --rm -it \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--name=$NAME \
		--device=/dev/dri:/dev/dri \
		$DOCKER_IMAGE_NAME:$BRANCH
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    # Do something under 64 bits Windows NT platform
	winpty docker run --rm -it -p 8080:8080/udp \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--name=$NAME \
		$DOCKER_IMAGE_NAME:$BRANCH


fi



