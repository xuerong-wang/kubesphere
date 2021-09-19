#!/bin/bash
mkfs.xfs /dev/sdb
pvcreate /dev/sdb
vgextend  centos /dev/sdb
lvresize -L +99G /dev/centos/root
xfs_growfs /dev/centos/root
