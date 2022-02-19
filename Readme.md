# CI "inspired" opensimrt docker

It's just their [CI yaml in docker format. ](https://github.com/mitkof6/OpenSimRT)


You need to have [docker installed](https://docs.docker.com/get-docker/).

Build with :

    $ bash build_docker_image.sh

Run with:

    $ bash run_docker_image.sh


To show graphics make sure you have either Xming or vcxsrv installed and running. 

Xming and vcxsrv will be running on the WSL ip address of your computer. You can check this IP by either opening a CMD (windows key + R then type cmd, in command prompt type ipconfig and use the IP from WSL) or by checking the log file from xming/ vcxsrv.

This ip will be used to set the DISPLAY variable which will run inside the docker as

    $ export DISPLAY=172.23.64.1:0.0

Or whatever your ip is. 

