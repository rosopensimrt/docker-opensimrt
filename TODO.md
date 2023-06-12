# TODO list:

- update tmux\_session package to make things more organized
- add .ssh config to a volume and mount it to be able to commit straight to remote repo
- remove unused frames from urdf
- make sinks and sources classes and put them in opensimrt\_core package
- make sure those sinks and sources abstract the communications parts from the special message types we are using, i.e. the nodes just need to read the opensimrt structures and publish those structures, the rest is handled by the common interface
- make sure that inverted quaternions used by opensimrt are all properly tracked, use special types, so we never try to use normal quaternion functions with them (because that will fail, you need to inver the w to get a proper quaternion rotation), this way we can zone in and find where exactly things went wrong and change the definitions internally so that we only use proper quaternions within the whole code
- create derivate class from urdf for osim models to be able to show the actual opensim model instead of relying on gepetto ospi library (should be a reimplementation of [robot\_state\_publisher](https://github.com/ros/robot_state_publisher/blob/rolling/src/robot_state_publisher.cpp), doesn't look too hard. we can probably still use the [kdl](https://www.orocos.org/kdl.html)  library, but I don't think it is necessary, since we have simtk/simbody doing this. So it is just a matter of parsing the .osim file and generating the Tfs. I still want to use the Rviz plugins and perhaps other things from Urdf, so it would be nice to lie to everyone that this is an urdf model somehow, though I am also not sure this is necessary either )

