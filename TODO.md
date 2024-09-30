# TODO list:

- save the SO output somehow (maybe both loggers and whole pipeline)
- add events to SO to measure also performance of RR

- update tmux\_session package to make things more organized
- add .ssh config to a volume and mount it to be able to commit straight to remote repo

- revamp the calibration code which is super janky. We do this using dynamic reconfigure messages which should provide a nice interface for also doing manual calibration. 

- Another cool feature would be to calibrate into a non-zero position, so can make it even closer to the vicon angles

- we also want to separate the axis convertions from the model to IMU/AR reference (TFServer stuff, this also needs cleanup) from the calibration values and make them independent from each other. 

- make this new calibration method works more consistently than before. Sometimes we get very weird movement from the AR node
- also those calibration values travel as valid quaternions. none of the inverted quaternion nonsense we have from opensimrt, that is wrong stuff and needs to be fixed as well. I recon we can try by removing all but one of the terms of the optimizer and fix so that it works with a single one without the invertion, then we zero out the weights on the other components and do this iteratively. It's the first step which would be the hardest. We can actually remove all the interfence from the optimizer if we test this only with the pelvis element (it would bypass the optimizer completely if we do this, i think).

- make sinks and sources classes and put them in opensimrt\_core package
- make sure those sinks and sources abstract the communications parts from the special message types we are using, i.e. the nodes just need to read the opensimrt structures and publish those structures, the rest is handled by the common interface
- make sure that inverted quaternions used by opensimrt are all properly tracked, use special types, so we never try to use normal quaternion functions with them (because that will fail, you need to inver the w to get a proper quaternion rotation), this way we can zone in and find where exactly things went wrong and change the definitions internally so that we only use proper quaternions within the whole code
- create derivate class from urdf for osim models to be able to show the actual opensim model instead of relying on gepetto ospi library (should be a reimplementation of [robot\_state\_publisher](https://github.com/ros/robot_state_publisher/blob/rolling/src/robot_state_publisher.cpp), doesn't look too hard. we can probably still use the [kdl](https://www.orocos.org/kdl.html)  library, but I don't think it is necessary, since we have simtk/simbody doing this. So it is just a matter of parsing the .osim file and generating the Tfs. I still want to use the Rviz plugins and perhaps other things from Urdf, so it would be nice to lie to everyone that this is an urdf model somehow, though I am also not sure this is necessary either )
- to add on the last point. No KDL, we just need to reimplement all of the public properties of the URDF class and that should behave like the URDF. Maybe I can even reuse the code for the RVIZdisplay class like this or the things from MoveIt. I might need to compile custom code for them though (to create the appropriate Class). If that is the case, then maybe I can also make more fundamental changes. To get only the TFs publishedf I have the impression it will be easier and I can get this from the model object somehow. I need to instrospect the visualization class to see how it does that. 

- are stage builds working?
- is the complete/incomplete build working?
- I think I should add tests for this. 

- I had another idea on how to deal with the whole sources sinks kind of thing. This would require each model to also provide the message definitions for their joints. The advantages of this would be having a simpler startup procedure and more ros compliance, but the nodes would get very messy because now they would need to be templated and the nodes would need to specify a model already. I am not sure this is better. Perhaps just using jointstates all the time is the way to go and we should abandon the opensim generic messages. This would require another message type very similar to jointstates for actuator states where we would send the generalized torques of every actuator. I need to double check how ros does this to avoid having to reinvent the triangular wheel. 
