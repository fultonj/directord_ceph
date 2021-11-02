#!/bin/bash

GIT=1
METAL=1
SSH=1
FILES=1
TMATE=1

if [ $GIT -eq 1 ]; then
    git config --global user.email fulton@redhat.com
    git config --global user.name "John Fulton"
fi

if [ $METAL -eq 1 ]; then
    NUM=$(cat ~/hosts | wc -l)
    ln -v -s directord-inventory-catalog${NUM}.yaml directord-inventory-catalog.yaml
    pushd ..
    ln -v -s task-core-inventory-ceph${NUM}.yaml task-core-inventory-ceph.yaml
    popd
    pushd ../../env
    ln -v -s deployed_metal${NUM}.yaml deployed_metal.yaml
    popd
fi

if [ $SSH -eq 1 ]; then
    if [[ ! -f ~/.ssh/config ]]; then
        echo StrictHostKeyChecking no > ~/.ssh/config
        chmod 0600 ~/.ssh/config
        rm -f ~/.ssh/known_hosts 2> /dev/null
        ln -s /dev/null ~/.ssh/known_hosts
    fi
    rm -f ~/.ssh/id_ed25519{,.pub}
    ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519
    for IP in $(cat ~/hosts | awk {'print $1'}); do
        ssh-copy-id -i ~/.ssh/id_ed25519 $IP
        ssh -i ~/.ssh/id_ed25519 $IP "tail -1 ~/.ssh/authorized_keys"
    done
fi

if [ $FILES -eq 1 ]; then
    cp -f -v directord-inventory-catalog.yaml ~/
fi

if [ $TMATE -eq 1 ]; then
    TMATER=2.4.0
    pushd /tmp/
    curl -OL https://github.com/tmate-io/tmate/releases/download/$TMATER/tmate-$TMATER-static-linux-amd64.tar.xz
    sudo mv tmate-$TMATER-static-linux-amd64.tar.xz /usr/src/
    popd
    pushd /usr/src/
    sudo tar xf tmate-$TMATER-static-linux-amd64.tar.xz
    sudo mv /usr/src/tmate-$TMATER-static-linux-amd64/tmate /usr/local/bin/tmate
    popd
    touch /home/stack/.tmate.conf
    tmate --help
fi
