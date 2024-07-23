echo -en '\e]0;[DEVEL]Instance session. Can be closed.\a'

docker exec -it opensimrt_ros_devel bash -l $@ 
