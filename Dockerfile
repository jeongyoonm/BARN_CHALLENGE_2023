FROM osrf/ros:noetic-desktop-full-focal

RUN apt-get update && apt-get install -y\
    git vim

RUN apt-get update && apt-get install -y \
    ros-noetic-jackal-gazebo ros-noetic-move-base

# for amrl_shared_lib used for webviz
RUN apt-get update && apt-get install -y \
    libgtest-dev libgoogle-glog-dev cmake build-essential 

# for webviz
RUN apt-get update && apt-get install -y \
    qt5-default libqt5websockets5-dev

# for graph navigation
RUN apt-get update && apt-get install -y \
    libgflags-dev liblua5.1-0-dev

# for enml
RUN apt-get update && apt-get install -y \
    g++ libpopt-dev libeigen3-dev \
    libjpeg8-dev libgoogle-perftools-dev \
    libsuitesparse-dev libblas-dev liblapack-dev libopenmpi-dev \
    libgflags-dev libceres-dev libtbb-dev \
    libncurses5-dev

RUN apt-get update && apt-get install -y \
    apt-utils \
    curl \
    python-is-python3 \
    python3-catkin-tools \
    python3-pip \
    software-properties-common \
    wget unzip tmux

RUN apt-get update && apt-get install -y \
    ros-noetic-jackal-msgs

RUN pip install scipy

# making bash as a default shell
SHELL ["/bin/bash", "-c"]

WORKDIR /
RUN mkdir /root/.ssh 
ADD id_rsa_passwordless /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# setup ROS related env vars
ENV ROS_VERSION=1
ENV ROS_DISTRO=noetic
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}/share/ros
ENV PATH=/opt/ros/${ROS_DISTRO}/bin:$PATH
ENV PYTHONPATH=/opt/ros/${ROS_DISTRO}/lib/python3/dist-packages:$PYTHONPATH

# setup repos
RUN mkdir ros-apps
WORKDIR /ros-apps
RUN git clone https://github.com/ut-amrl/BARN_CHALLENGE_2023.git
WORKDIR /ros-apps/BARN_CHALLENGE_2023
RUN git checkout clean
RUN mkdir scripts
RUN git submodule update --recursive --init
#ADD build_packages_new.sh .
#ADD build_packages_clean_new.sh .

#WORKDIR /ros-apps/BARN_CHALLENGE_2023/third_party/amrl_msgs
#ENV ROS_PACKAGE_PATH=/ros-apps/BARN_CHALLENGE_2023/third_party/amrl_msgs:${ROS_PACKAGE_PATH}
#RUN echo $ROS_PACKAGE_PATH
#RUN source ../../set_env.sh
#RUN make -j8

# ENV ROS_PACKAGE_PATH=/ros-apps/BARN_CHALLENGE_2023:/ros-apps/BARN_CHALLENGE_2023/third_party/amrl_msgs:$ROS_PACKAGE_PATH
# ENV ROS_VERSION=1
# ENV ROS_DISTRO=noetic
# ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}/share/ros
# ENV PATH=/opt/ros/${ROS_DISTRO}/bin:$PATH
# ENV PYTHONPATH=/opt/ros/${ROS_DISTRO}/lib/python3/dist-packages:$PYTHONPATH
# RUN echo $ROS_PACKAGE_PATH
# RUN bash build_packages.sh
