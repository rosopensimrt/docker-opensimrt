BRANCH=$(git branch --show-current )
if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform        
	docker build . -f ros.Dockerfile -t mysablehats/opensim-rt:$BRANCH
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
	DOCKER_BUILDKIT=1 docker build . -f ros.Dockerfile --progress=tty -t mysablehats/opensim-rt:$BRANCH
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Do something under 32 bits Windows NT platform
	docker build . -f ros.Dockerfile -t mysablehats/opensim-rt:$BRANCH
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    # Do something under 64 bits Windows NT platform
	docker build . -f ros.Dockerfile -t mysablehats/opensim-rt:$BRANCH

fi











