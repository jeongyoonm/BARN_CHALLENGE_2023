#!/bin/bash

ut_jackal_path=$(realpath third_party/ut_jackal)
echo $ut_jackal_path
graph_nav_path=$(realpath third_party/ut_jackal/graph_navigation)
echo $graph_nav_path

if [[ $ROS_PACKAGE_PATH == *"ut_jackal"* ]]; then
    echo "Removing ut_jackal from ROS_PACKAGE_PATH..."
    export ROS_PACKAGE_PATH=$(echo $ROS_PACKAGE_PATH | tr ':' '\n' | grep -v "ut_jackal" | paste -sd: -)
fi
# Add the new path to ROS_PACKAGE_PATH
if [[ $ROS_PACKAGE_PATH != *"$ut_jackal_path"* ]]; then
    echo "Adding $ut_jackal_path to ROS_PACKAGE_PATH..."
    export ROS_PACKAGE_PATH=$ut_jackal_path:$ROS_PACKAGE_PATH
fi

if [[ $ROS_PACKAGE_PATH == *"graph_navigation"* ]]; then
    echo "Removing graph_navigation from ROS_PACKAGE_PATH..."
    export ROS_PACKAGE_PATH=$(echo $ROS_PACKAGE_PATH | tr ':' '\n' | grep -v "graph_navigation" | paste -sd: -)
fi
# Add the new path to ROS_PACKAGE_PATH
if [[ $ROS_PACKAGE_PATH != *"$graph_nav_path"* ]]; then
    echo "Adding $graph_nav_path to ROS_PACKAGE_PATH..."
    export ROS_PACKAGE_PATH=$graph_nav_path:$ROS_PACKAGE_PATH
fi

cd third_party/amrl_msgs
git checkout master # to include NavStatusMsg.msg
export ROS_PACKAGE_PATH=${PWD}:${ROS_PACKAGE_PATH}
make -j8
cd - 

cd src/jackal_helper/script
chmod +x *.sh
find . -name "*.py" -exec chmod +x {} \;
cd -

# git submodule update --recursive --init
# export ROS_PACKAGE_PATH=`pwd`:$ROS_PACKAGE_PATH

#cd third_party/amrl_msgs
#make -j12 

#for graph-nav dependency
cd third_party
git clone https://github.com/stereolabs/zed-ros-interfaces.git
cd zed-ros-interfaces
export ROS_PACKAGE_PATH=${PWD}:${ROS_PACKAGE_PATH}
mkdir build
cd build
cmake ..
make -j8
export PKG_CONFIG_PATH=/ros-apps/BARN_CHALLENGE_2023/third_party/zed-ros-interfaces/build/catkin_generated/installspace:${PKG_CONFIG_PATH}
cd ../../

#for graph-nav dependency
cd /opt
wget https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-1.13.0%2Bcpu.zip
unzip libtorch-cxx11-abi-shared-with-deps-1.13.0+cpu.zip
cd -

cd /ros-apps/BARN_CHALLENGE_2023/third_party/ut_jackal
make -j12

cd ../voronoi_global_planner
git checkout main

cd ../..
catkin_make
