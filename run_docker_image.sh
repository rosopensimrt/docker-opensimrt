#!/bin/bash
#BRANCH=latest
BRANCH_RAW=$(git branch --show-current )
## sanitize branch name
sanitize_tag() {
    echo "$1" | sed -e 's/[^a-zA-Z0-9._-]/_/g' | tr '[:upper:]' '[:lower:]' | sed -e 's/^[-._]//g' -e 's/[-._]$//g'
}
BRANCH=$(sanitize_tag "$BRANCH_RAW")
NAME=${1:-opensimrt_ros_}
CATKIN_WS_DIR=${2:-$(pwd)/catkin_ws}
mkdir -p $CATKIN_WS_DIR/devel
mkdir -p $CATKIN_WS_DIR/build
DOCKER_IMAGE_NAME=rosopensimrt/opensim-rt:$BRANCH
#DOCKER_IMAGE_NAME=rosopensimrt/opensim-rt:devel-all
THIS_WINDOW_TITLE="MAIN WINDOW DO NOT CLOSE!!!! [$CATKIN_WS_DIR] $BRANCH"

echo -en "\e]0;${THIS_WINDOW_TITLE}\a"

#IIRC this is to share the realsense camera
BUS=$(lsusb | grep 8086 | cut -d " " -f 2)
PORT=$(lsusb | grep 8086 | cut -d " " -f 4 | cut -d ":" -f 1)

USE_ANDROID_VM=false #true
BT_DONGLE_VENDOR_ID=0bda:8771

if [ "$(uname)" == "Darwin" ]; then
	# Do something under Mac OS X platform
	# I can only run in x86_64 systems, so I should also warn the person.
	if [ "$(uname -m)" != "x86_64" ]; then
		echo "The only currently supported architecture is x86_64. You need to change the ros.Dockerfile to compile everything with this architecture ($(uname -m))."
		exit
	fi
	docker run --rm -it \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--name=$NAME \
		--device=/dev/dri:/dev/dri \
		$DOCKER_IMAGE_NAME
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	# Do something under GNU/Linux platform

	# I think this is a linux only issue.
	DOCKER_DEAMON_PROCESS_OWNER=$(ps aux | grep [d]ockerd | awk '{print $1}')
	if [ "$DOCKER_DEAMON_PROCESS_OWNER" != "root" ]; then
		printf "\e[33m\n\tWARNING:\tWhen using docker rootless, the volumes won't mount properly, which means you wont be able to save data.\n\n"
		printf "\tTo save data, you need to make the volume belong to the subuser that is running inside the container.\n"
		printf "\tTo do this you need to start a \"root\" instance and use chown -R and set it to the name of the user that was used to build the container\n"
		printf "\tafter you are done with it you can just chown recursively to your own user outside the docker container.\n\n\e[0m"
	fi

	# I can only run in x86_64 systems, so I should also warn the person.
	if [ "$(uname -m)" != "x86_64" ]; then
		echo "The only currently supported architecture is x86_64. You need to change the ros.Dockerfile to compile everything with this architecture ($(uname -m))."
		exit
	fi
	USER_UID=$(id -u)
	

	if [ "$USE_ANDROID_VM" = true ]; then #bash is weird...
		#let's also run the vm for the android device
		# it doesnt seem to work if the bt dongle is already plugged in, so let's check for that
		BT_INSERTED=$(lsusb -d $BT_DONGLE_VENDOR_ID)
		if [[ $BT_INSERTED ]]; then
			echo "Remove BT device before starting VM..."
			exit 0
		fi
		echo "You can put the dongle after the android vm has started"
		scripts/how_to_start_bt_androidx86_vm.py &
	fi
	## slightly better alternative, untested:
	#xhost +
	xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f /tmp/.docker.xauth nmerge -

	FILES="/dev/video*"
	LINE=""
	for f in $FILES
	do
		#echo "Adding video device $f ..."
		# take action on each file. $f store current file name
		LINE="--device=$f:$f $LINE"
	done
	#echo $LINE

	#not sure if I need to expose these ports, but it is working
	#docker run --rm -it --network=host \
	docker run --rm -it \
		-p 9000:9000/udp \
		-p 8001:8001/udp \
		-p 10000:10000/udp \
		-p 9999:9999 \
		-p 1030:1030/udp \
		-e WINDOW_TITLE="${THIS_WINDOW_TITLE}" \
		-e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /tmp/.docker.xauth:/tmp/.docker.xauth:rw -e XAUTHORITY=/tmp/.docker.xauth \
		--name=$NAME \
		--device=/dev/snd:/dev/snd \
		--device=/dev/dri:/dev/dri $LINE \
		-v $CATKIN_WS_DIR:/catkin_ws \
		-v $(pwd)/Data:/srv/host_data \
		-v $(pwd)/tmux:/usr/local/bin/tmux_session \
		-v /run/user/${USER_UID}/pulse:/run/user/1000/pulse \
		--volume /dev/bus/usb/$BUS/$PORT:/dev/bus/usb/$BUS/$PORT \
		-e PULSE_SERVER=unix:/run/user/1000/pulse/native \
		$DOCKER_IMAGE_NAME /bin/bash -l
		#-u 1000:1000
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
	# Do something under 32 bits Windows NT platform
	docker run --rm -it \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--name=$NAME \
		--device=/dev/dri:/dev/dri \
		$DOCKER_IMAGE_NAME
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
	# Do something under 64 bits Windows NT platform
	winpty docker run --rm -it -p 8080:8080/udp \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--name=$NAME \
		$DOCKER_IMAGE_NAME


fi
echo -en "\e]0;Terminal\a"





