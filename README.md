# directord_ceph

Use [directord and task-core](https://github.com/Directord) to deploy ceph.

## Prerequisites

[Optional] I make two centos-stream8 VMs on a hypervisor by running
- [./centos.sh](https://github.com/fultonj/tripleo-laptop/blob/master/centos.sh)
- [./clone.sh node 2](https://github.com/fultonj/tripleo-laptop/blob/master/clone.sh)

I can then do the following:
```
ssh stack@node0
ssh stack@node1
```
On node0:/home/stack/ I'm keeping the contents of this git repository.

## Environment

- [env.sh](env.sh)

The above script does the following based on the
[tripleo-directord-hackfest](https://etherpad.opendev.org/p/tripleo-directord-hackfest).

- clone [directord](https://github.com/directord/directord) into ~/stack
- install directord for use via `source /opt/directord/bin/activate`
- bootstrap directord on the two nodes so you can use `directord manage --list-nodes`
- clone [task-core](https://github.com/directord/task-core) into ~/stack
- install task-core for use via `/opt/directord/bin/task-core`

The [env](env) directory contains scripts to support the above and the
following files which get copied into the cloned ~/task-core directory:

## Deploy

- [deploy.sh](deploy.sh)

The above script will copy files from the [env](env) and
[examples/directord/services](examples/directord/services)
directories into ~/task-core and then run `task-core` to
deploy ceph on the nodes.

- [2node_config.yaml](env/2node_config.yaml)
Overwrite the default 2node_config.yaml so that the following file is copied in instead
- [task-core-ceph.yaml](env/task-core-ceph.yaml)
Define variables necessary to deploy your service including your service's variables
- [2node_roles_ceph.yaml](env/2node_roles_ceph.yaml)
Map roles to services; include your new service on the role that needs it
- [task-core-inventory-ceph.yaml](env/task-core-inventory-ceph.yaml)
Map nodes to roles
- [os-net-config.yaml](env/os-net-config.yaml)
Overwrite the default 
[os-net-config.yaml](https://github.com/directord/task-core/blob/main/examples/directord/services/os-net-config.yaml)
file so that it uses my own 
[os-net-config.yaml.j2](env/os-net-config.yaml.j2) 
(I need it to update nic1, not nic2).


## Examples

The [examples/directord/services](examples/directord/services)
directory contains the task-core services necessary to deploy Ceph via
cephadm. The structure is modeled after the task-core project's
[services](https://github.com/directord/task-core/tree/main/examples/directord/services)
directory which contains the task-core services necessary to deploy
OpenStack.
