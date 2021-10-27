#!/bin/bash

CACHE=0
PURGE=0
COPY=1
RUN=1

source /opt/directord/bin/activate

if [ $CACHE -eq 1 ]; then
    # Clean cache on all nodes
    directord exec --verb CACHEEVICT all
fi

if [ $PURGE -eq 1 ]; then
    directord manage --purge-jobs
fi


if [ $COPY -eq 1 ]; then
    pushd env

    cp -v -f task-core-inventory-ceph.yaml ~/
    cp -v -f task-core-ceph.yaml ~/
    cp -v -f 2node_config.yaml ~/task-core/examples/directord/services/2node_config.yaml
    cp -v -f 2node_roles_ceph.yaml ~/task-core/examples/directord/basic/2node_roles_ceph.yaml
    popd

    pushd examples/directord/services
    cp -v -f *.yaml ~/task-core/examples/directord/services/
    popd

    pushd examples/directord/services/files/
    for D in $(ls); do
        cp -r -v -f $D ~/task-core/examples/directord/services/files/;
    done
    popd
fi


if [ $RUN -eq 1 ]; then
    pushd ~/task-core/examples/directord/services
    task-core -s . \
              -i ~/task-core-inventory-ceph.yaml \
              -r ../basic/2node_roles_ceph.yaml -d
    popd
fi
