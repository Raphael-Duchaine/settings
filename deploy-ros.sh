#!/bin/bash
#
# This install automatically ROS and workspace for work on SARA
#
# @author:        Lucas Maurice
# @organisation:  Walking Machine
# @date:          14/06/2018

# Prepare ROS installation
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt update

# Install ROS and dependencies
sudo apt install -y ros-melodic-desktop-full
sudo apt install -y python-rosinstall python-rosinstall-generator python-wstool build-essential
sudo apt install -y ros-melodic-ros-control ros-melodic-hardware-interface ros-melodic-moveit ros-melodic-navigation
sudo apt install -y ffmpeg
sudo apt install -y python-imaging python-imaging-tk
python -m pip install --user --upgrade pip
python -m pip install Pillow

# Initialise ROS
sudo rosdep init
rosdep update

# Prepare workspace
case $SHELL in
*/zsh)
    source /opt/ros/melodic/setup.zsh
    ;;
*)
    source /opt/ros/melodic/setup.bash
esac

mkdir ~/sara_ws/src/ -p
cd ~/sara_ws/
catkin_make

# Get wm main repositories
# cd ~/sara_ws/src
# git clone git@github.com:WalkingMachine/sara_msgs.git
# git clone git@github.com:WalkingMachine/sara_launch.git
# git clone git@github.com:WalkingMachine/sara_behaviors.git
# git clone git@github.com:WalkingMachine/wonderland.git
# git clone git@github.com:WalkingMachine/wm_object_detection.git
#
# # Install Wonderland
# cd ~/sara_ws/src/wonderland
# ./install.sh
#
# # Install Behavior
# cd ~/sara_ws/src/sara_behaviors
# ./install.sh
#
# # Build workspace
# cd ~/sara_ws
# catkin_make
#
# # Source workspace
# source ~/sara_ws/src/sara_launch/sh_files/sararc.sh

# Write sources in bashrc
if !(grep --quiet "# FOR ROS" ~/.bashrc); then
    echo Deploy Source to .bashrc
    echo "# FOR ROS" >> ~/.bashrc
    echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
    #TODO: Work Again with this: echo "source ~/sara_ws/src/sara_launch/sh_files/sararc.sh" >> ~/.bashrc
fi

# Write sources in zshrc
if !(grep --quiet "# FOR ROS" ~/.zshrc); then
    echo Deploy Source to .zshrc
    echo "# FOR ROS" >> ~/.zshrc
    echo "source /opt/ros/melodic/setup.zsh" >> ~/.zshrc
    #TODO: Work Again with this: echo "source ~/sara_ws/src/sara_launch/sh_files/sararc.sh" >> ~/.zshrc
fi
