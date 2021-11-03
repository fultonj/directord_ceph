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

- [2node_config.yaml](env/2node_config.yaml)
Overwrite the default 2node_config.yaml so that the following file is copied in instead
- [task-core-ceph.yaml](env/task-core-ceph.yaml)
Define variables necessary to deploy your service including your service's variables
- [2node_roles_ceph.yaml](env/2node_roles_ceph.yaml)
Map roles to services; include your new service on the role that needs it
- [task-core-inventory-ceph6.yaml](env/task-core-inventory-ceph6.yaml)
Map nodes to roles


## Deploy

- [deploy.sh](deploy.sh)

The above script will copy files from the [env](env) and
[examples/directord/services](examples/directord/services)
directories into ~/task-core and then run `task-core` to
deploy ceph on the nodes.


## Examples

The [examples/directord/services](examples/directord/services)
directory contains the task-core services necessary to deploy Ceph via
cephadm. The structure is modeled after the task-core project's
[services](https://github.com/directord/task-core/tree/main/examples/directord/services)
directory which contains the task-core services necessary to deploy
OpenStack.

## Results and Next Steps

I can deploy a cluster w/ 3 mon nodes and 3 ceph-storage nodes (15 total OSDs)

To get OpenStack working with RBD I could add these services to this
POC to do the following:

- Add OpenStack pools to the Ceph cluster to take the place of [pools](https://github.com/openstack/tripleo-ansible/blob/master/tripleo_ansible/roles/tripleo_cephadm/tasks/pools.yaml)
though I would not thave the ansible module

- Add OpenStack key to the Ceph cluster to take the place of [keys](https://github.com/openstack/tripleo-ansible/blob/master/tripleo_ansible/roles/tripleo_cephadm/tasks/keys.yaml) though I would not thave the ansible module

- Export OpenStack configuration like deployed_ceph does (replace [export.yaml](https://github.com/openstack/tripleo-ansible/blob/master/tripleo_ansible/roles/tripleo_cephadm/tasks/export.yaml) and its [template](https://github.com/openstack/tripleo-ansible/blob/master/tripleo_ansible/roles/tripleo_cephadm/templates/ceph_client.yaml.j2))

- Write replacement for [tripleo_ceph_client](https://github.com/openstack/tripleo-ansible/tree/master/tripleo_ansible/roles/tripleo_ceph_client/tasks)

Other tasks will be needed for other [services](https://github.com/openstack/tripleo-ansible/tree/master/tripleo_ansible/roles/tripleo_cephadm/tasks)
like RGW.
