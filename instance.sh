WINDOW_TITLE="[DEVEL]Instance session. Can be closed."
echo -en "\e]0;${WINDOW_TITLE}\a"

CONTAINER_NAME=${1:-opensimrt_ros_}

shift

if [[ $# -gt 0 ]]; then
	echo "Get arguments: $@"
	docker exec -it -e WINDOW_TITLE="${WINDOW_TITLE}" ${CONTAINER_NAME} gosu rosopensimrt bash -l -c $@
else
	echo "No arguments were provided."
	docker exec -it -e WINDOW_TITLE="${WINDOW_TITLE}" ${CONTAINER_NAME} gosu rosopensimrt bash -l 
fi

echo -en "\e]0;Terminal\a"

