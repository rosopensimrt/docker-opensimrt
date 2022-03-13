# CI "inspired" opensimrt docker

It's just their [CI yaml in docker format. ](https://github.com/mitkof6/OpenSimRT)


You need to have [docker installed](https://docs.docker.com/get-docker/).

Build with :

    $ bash build_docker_image.sh

Run with:

    $ bash run_docker_image.sh

# Docker builds

If instead you just want to use the already built docker image, you get it [here](https://hub.docker.com/r/mysablehats/opensim-rt/tags). We are not freezing versions, so it is possible that this will break in the future. 

The docker with the default version from mitkof6/OpenSIMRT can be obtained with: 

     docker pull mysablehats/opensim-rt:main

It can also be directly accessed [here](https://hub.docker.com/layers/mysablehats/opensim-rt/main/images/sha256-f3f238759e736f2fd01b9a1eec307b9dbe664f97206e438541bb2685b9fcb38e).

# Linux Users:

You need to allow "remote" connections to your X server:

    $ xhost +

Everything else should just work. If it doesn't open an issue.  


# Windows Users:

To show graphics make sure you have either Xming or vcxsrv installed and running. 

Xming and vcxsrv will be running on the WSL ip address of your computer. You can check this IP by either opening a CMD (windows key + R then type cmd, in command prompt type ipconfig and use the IP from WSL) or by checking the log file from xming/ vcxsrv.

This ip will be used to set the DISPLAY variable which will run inside the docker as

    $ export DISPLAY=172.23.64.1:0.0

Or whatever your ip is. 

