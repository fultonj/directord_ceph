#!/bin/bash

# directord

pushd env/directord/
bash pre.sh
bash install.sh
bash bootstrap.sh
bash chmod.sh
popd

ln -s /opt/directord/bin/activate
source /opt/directord/bin/activate
directord manage --list-nodes

# task-core

pushd env/task-core/
bash install.sh
popd
