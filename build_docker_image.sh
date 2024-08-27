BRANCH_RAW=$(git branch --show-current )
## sanitize branch name
sanitize_tag() {
    echo "$1" | sed -e 's/[^a-zA-Z0-9._-]/_/g' | tr '[:upper:]' '[:lower:]' | sed -e 's/^[-._]//g' -e 's/[-._]$//g'
}
BRANCH=$(sanitize_tag "$BRANCH_RAW")
USERNAME=rosopensimrt
#VIDEOGROUP=$(getent group video | awk -F: '{print $3}')
if [ "$(uname)" == "Darwin" ]; then
	# Do something under Mac OS X platform
	# I can only run in x86_64 systems, so I should also warn the person.
	if [ "$(uname -m)" != "x86_64" ]; then
		echo "The only currently supported architecture is x86_64. You need to change the ros.Dockerfile to compile everything with this architecture ($(uname -m))."
		exit
	fi
	docker build . -f ros.Dockerfile -t ${USERNAME}/opensim-rt:$BRANCH $@

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	# Do something under GNU/Linux platform
	# I can only run in x86_64 systems, so I should also warn the person.
	if [ "$(uname -m)" != "x86_64" ]; then
		echo "The only currently supported architecture is x86_64. You need to change the ros.Dockerfile to compile everything with this architecture ($(uname -m))."
		exit
	fi
	#DOCKER_BUILDKIT=1 docker build . -f ros.Dockerfile --build-arg VIDEOGROUP=${VIDEOGROUP} --progress=tty -t ${USERNAME}/opensim-rt:$BRANCH
	#DOCKER_BUILDKIT=1 docker build . -f Dockerfile.first --progress=tty -t opensim-rt1 --build-arg user=$USER --build-arg group=$(id -g -n) --build-arg uid=$(id -u) --build-arg gid=$(id -g) $@
	#DOCKER_BUILDKIT=1 docker build . -f Dockerfile.second --progress=tty -t opensim-rt2 --build-arg user=$USER --build-arg group=$(id -g -n) --build-arg uid=$(id -u) --build-arg gid=$(id -g) $@
	#DOCKER_BUILDKIT=1 docker build . -f Dockerfile.third --progress=tty -t opensim-rt3 --build-arg user=$USER --build-arg group=$(id -g -n) --build-arg uid=$(id -u) --build-arg gid=$(id -g) $@
	DOCKER_BUILDKIT=1 docker build . -f ros.Dockerfile --progress=tty -t ${USERNAME}/opensim-rt:$BRANCH --build-arg user=$USER --build-arg group=$(id -g -n) --build-arg uid=$(id -u) --build-arg gid=$(id -g) $@

elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
	# Do something under 32 bits Windows NT platform
	docker build . -f ros.Dockerfile -t ${USERNAME}/opensim-rt:$BRANCH $@

elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
	# Do something under 64 bits Windows NT platform
	docker build . -f ros.Dockerfile -t ${USERNAME}/opensim-rt:$BRANCH $@

fi












