#!/bin/sh
#
# Installs a bunch of common programs that we all know and like
#

sudo apt-get install -y tmux htop vim git xfsprogs

# we're a python shop, let's accept that
sudo apt-get install -y python-dev ipython python-pip

# for docker
sudo apt-get install -y linux-image-generic-lts-raring
sudo apt-get install -y linux-headers-generic-lts-raring
