BRANCH=$(git branch --show-current )
USERNAME=mysablehats
#VIDEOGROUP=$(getent group video | awk -F: '{print $3}')
if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform        
	docker build . -f ros.Dockerfile -t ${USERNAME}/opensim-rt:$BRANCH $@
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
	#DOCKER_BUILDKIT=1 docker build . -f ros.Dockerfile --build-arg VIDEOGROUP=${VIDEOGROUP} --progress=tty -t ${USERNAME}/opensim-rt:$BRANCH
	DOCKER_BUILDKIT=1 docker build . -f ros.Dockerfile --progress=tty -t ${USERNAME}/opensim-rt:$BRANCH --build-arg user=$USER --build-arg group=$(id -g -n) --build-arg uid=$(id -u) --build-arg gid=$(id -g) $@
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Do something under 32 bits Windows NT platform
	docker build . -f ros.Dockerfile -t ${USERNAME}/opensim-rt:$BRANCH $@
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    # Do something under 64 bits Windows NT platform
	docker build . -f ros.Dockerfile -t ${USERNAME}/opensim-rt:$BRANCH $@

fi











