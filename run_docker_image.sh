#!/usr/bin/env bash
docker run --rm --network=host -it \
	-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
	--device=/dev/dri:/dev/dri \
	mysablehats/opensim-rt:latest
