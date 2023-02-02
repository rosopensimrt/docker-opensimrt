# create directory launch in human_control
# joints do not always need limits, so you can try except joint_limits linei
#
# another issue is that knees are defined as custom joints with a spline in our model, so they don't have the proper offset. the offset was fixed manually to allow correct display of hte model

#
git clone https://gitlab.inria.fr/elandais/ospi2urdf.git
apt-get install python3-numpy libeigen3-dev
pip install numpy-stl
##install eigenpy
git clone https://github.com/stack-of-tasks/eigenpy.git
cd eigenpy
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DPYTHON_EXECUTABLE=/usr/bin/python3
make -j 4
make install

git clone --recursive https://github.com/stack-of-tasks/pinocchio
cd pinocchio

## ADD THIS LINE
# find_package (Python3 COMPONENTS Interpreter NumPy)
# To cmakelists.txt


export PYTHONPATH=/usr/local/lib/python3/dist-packages:$PYTHONPATH
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DPYTHON_EXECUTABLE=/usr/bin/python3
make -j 4
make install

#last install the stl converter

git clone https://github.com/vmtk/vmtk.git
cd vmtk
mkdir build
cd build
cmake ..
make
source Install/vmtk_env.sh

