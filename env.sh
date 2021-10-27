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
if [[ $? -gt 0 ]]; then
    echo "ERROR: no nodes"
    echo "directord manage --list-nodes"
    exit 1
fi

# task-core

pushd env/task-core/
bash install.sh
popd
