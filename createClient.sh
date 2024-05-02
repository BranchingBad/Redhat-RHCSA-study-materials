#!/bin/bash

vmName=rhel9-workstation
vmCreateDate=$(date +"%Y-%m-%d %H:%M:%S")
vmRoot=/home/$USER
vmStore=$vmRoot/virtual-machines
vmISO=rhel-9.4-x86_64-dvd.iso
vmISOlocation=$vmRoot/iso/$vmISO

# Check if directory exists using test command with -d flag
if ! test -d "$vmStore"; then
  mkdir -p "$vmStore"
  echo "Directory '$vmStore' created successfully."
else
  echo "Directory '$vmStore' already exists."
fi

echo 'Creating directories'
mkdir -vp $vmStore/$vmName
cd $vmStore/$vmName

#Meta data creation
echo 'Creating meta-data file'
touch meta-data

cat <<EOF > meta-data   
instance-id: $vmName
local-hostname: $vmName
create-date: $vmCreateDate
kick-start: ksSrv.cfg
vm-cpu: 2
vm-memory: 4096
vm-network: bridge
vm-image-file-format: qcow2
vm-image-file[0]-name: $vmName.qcow2
vm-image-file[0]-size: 30G
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
--os-variant=rhel9.4 \
--graphics spice \
--location=$vmISO \
--check path_in_use=off \
--initrd-inject '/home/'$USER'/git-projects/rhcsa-study/kickstart/ksClient.cfg' \
--extra-args 'inst.ks=file:/ksClient.cfg'