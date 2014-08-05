#!/bin/bash -xe
#
# Author:: Noah Kantrowitz <noah@coderanger.net>
#
# Copyright 2014, Balanced, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

sudo apt-get update -y

# Fix stupid grub upgrading prompt issue
# https://bugs.launchpad.net/ubuntu/+source/apt/+bug/1323772
sudo rm /boot/grub/menu.lst
sudo update-grub-legacy-ec2 -y
sudo apt-get -y dist-upgrade

# Install ec2-ami-tools
sudo apt-get upgrade -y
sudo apt-get install -y unzip
curl -o /tmp/ec2-ami-tools.zip http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools.zip
# The Amazon zip file has recoverable errors
(
set +e
unzip -d /tmp /tmp/ec2-ami-tools.zip
RV="$?"
if [[ "$RV" -gt 1 ]]; then
  exit "$RV"
fi
set -e
)
rm /tmp/ec2-ami-tools.zip
sudo mkdir /opt/ec2-ami-tools
sudo mv /tmp/ec2-ami-tools*/* /opt/ec2-ami-tools
rm -rf /tmp/ec2-ami-tools*
sudo chown -R root:root /opt/ec2-ami-tools

# Notice: install pip not by using apt-get for sovling a bug
# (introduced by aws-cfn-bootstrap, version conflict of requests 1.2.3 and 2.x)
# https://bugs.launchpad.net/ubuntu/+source/python-pip/+bug/1306991
wget -O - https://raw.githubusercontent.com/pypa/pip/1.5.6/contrib/get-pip.py | sudo python
# more bootstrapping
sudo rm -rf /usr/local/lib/python2.7/dist-packages/requests-1.2.3.egg-info/
sudo pip install /tmp/aws-cfn-bootstrap-20140311.tar.gz
sudo pip install awscli
sudo mv /tmp/jq /usr/bin/
sudo chmod 755 /usr/bin/jq

# this is really slow to build on instances, let's build it here such performance
sudo apt-get -y install build-essential

# install docker
# per http://docs.docker.com/installation/ubuntulinux/
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo sh -c "echo deb https://get.docker.io/ubuntu docker main\
> /etc/apt/sources.list.d/docker.list"
sudo apt-get update -y
sudo apt-get install lxc-docker -y

# install docker hub authentication configuration
sudo mv /tmp/.dockercfg /root/.dockercfg
sudo chown root:root /root/.dockercfg
sudo chmod 400 /root/.dockercfg
sudo cp /root/.dockercfg /home/ubuntu/.dockercfg
sudo chown ubuntu:ubuntu /home/ubuntu/.dockercfg

# preinstall base docker images
sudo docker pull balanced/base
