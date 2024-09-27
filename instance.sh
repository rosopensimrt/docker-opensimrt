WINDOW_TITLE="[DEVEL]Instance session. Can be closed."
echo -en "\e]0;${WINDOW_TITLE}\a"

CONTAINER_NAME=${1:-opensimrt_ros_}

shift

docker exec -it -e WINDOW_TITLE="${WINDOW_TITLE}" ${CONTAINER_NAME} gosu rosopensimrt:rosopensimrt bash -l $@

echo -en "\e]0;Terminal\a"

