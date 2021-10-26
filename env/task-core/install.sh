#!/bin/bash

pushd ~
sudo dnf -y install cmake make gcc gcc-c++ openssl-devel
sudo dnf -y update libarchive

if [[ ! -d ~/task-core ]]; then
    git clone https://github.com/directord/task-core
fi

sudo /opt/directord/bin/pip3 install task-core/
popd
