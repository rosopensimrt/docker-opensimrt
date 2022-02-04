if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform        
	docker run --rm --network=host -it \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--device=/dev/dri:/dev/dri \
		mysablehats/opensim-rt:latest
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
	docker run --rm -it -p 8080:8080/udp \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--device=/dev/dri:/dev/dri \
		mysablehats/opensim-rt:devel
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Do something under 32 bits Windows NT platform
	docker run --rm --network=host -it \
		-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
		--device=/dev/dri:/dev/dri \
		mysablehats/opensim-rt:latest
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    # Do something under 64 bits Windows NT platform
	/C/Program\ Files\ \(x86\)/Xming/Xming.exe :0 -multiwindow -silent-dup-error &
    	IP=$( grep -E "Xdm" /c/Users/frekle/AppData/Local/Temp/Xming.0.log | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])')
    	export DISPLAY=$IP:0.0
	winpty docker run --rm -it -p 8080:8080/udp -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix mysablehats/opensim-rt:devel


fi



