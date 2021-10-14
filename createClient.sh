#!/bin/bash

vmName=node1
vmStore=/home/steve/virtual-machines
vmISO=/home/steve/iso/rhel-8.4-x86_64-dvd.iso

echo 'Creating directories'
mkdir -vp $vmStore/$vmName
cd $vmStore/$vmName

#Meta data creation
echo 'Creating meta-data file'
touch meta-data

cat <<EOF > meta-data
instance-id: $vmName
local-hostname: $vmName
EOF

#Create storage pool
echo 'Create storage pool'
virsh pool-create-as --name $vmName --type dir --target $vmStore/$vmName

#primary O/S disk
echo 'Create disk for O/S'
export LIBGUESTFS_BACKEND=direct
qemu-img create -f qcow2 -o preallocation=metadata $vmName.qcow2 40G

#Create virtual machine
echo 'Create new virtual machine'
virt-install --name $vmName \
--memory 2048 --vcpus 2 --cpu host \
--disk $vmName.qcow2,format=qcow2,bus=virtio \
--network bridge=virbr0,model=virtio \
--os-type=linux \
--os-variant=rhel8.4 \
--graphics spice \
--location=$vmISO \
--check path_in_use=off \
--initrd-inject '/home/steve/git-projects/rhcsa-study/kickstart/ksClient.cfg' \
--extra-args 'inst.ks=file:/ksClient.cfg'