#!/bin/bash

vmName=srvVm
vmStore=/home/steve/vm
vmISO=/home/steve/vm/iso/CentOS-7-x86_64-DVD-1810.iso

#Remove virtual machine
echo 'Shuting down and removing virtual machine'
virsh destroy $vmName
sleep 10
virsh undefine $vmName
virsh list --all

#Remove storage pool
echo 'Removing storage pool'
virsh pool-destroy $vmName
virsh pool-list

#Remove srv folder and contents
echo 'Removing server directory and contents (verbose + verify)'
rm -rfv $vmStore/$vmName

