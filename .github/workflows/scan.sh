#!/bin/bash
ls /sys/class/scsi_host/
echo "- - -" > /sys/class/scsi_host/host0/scan
echo "- - -" > /sys/class/scsi_host/host1/scan
echo "- - -" > /sys/class/scsi_host/host2/scan
fdisk -l |grep sdb
lsblk
