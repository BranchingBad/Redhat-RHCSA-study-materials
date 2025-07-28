#!/bin/bash

vmName=rhel10-server
vmCreateDate=$(date +"%Y-%m-%d %H:%M:%S")
vmRoot=/home/$USER
vmStore=$vmRoot/virtual-machines
vmISO=rhel-10.0-x86_64-dvd.iso
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
iso: $vmISO
vm-cpu: 2
vm-memory: 4096
vm-network: bridge
vm-image-file-format: qcow2
vm-image-file[0]-name: $vmName.qcow2
vm-image-file[0]-size: 30G
vm-image-file[1]-name: $vmName.spare.qcow2
vm-image-file[1]-size: 10G
EOF

#Create storage pool
echo 'Create storage pool'
virsh pool-create-as --name $vmName --type dir --target $vmStore/$vmName

#primary O/S disk
echo 'Create disk for O/S'
export LIBGUESTFS_BACKEND=direct
qemu-img create -f qcow2 -o preallocation=metadata $vmName.qcow2 30G

#Spare vm for VG/LVM practice
echo 'Create disk for practice'
qemu-img create -f qcow2 -o preallocation=metadata $vmName.spare.qcow2 10G

#Create virtual machine
echo 'Create new virtual machine'
virt-install --name $vmName \
--memory 4096 --vcpus 2 --cpu host \
--disk $vmName.qcow2,format=qcow2,bus=virtio \
--disk $vmName.spare.qcow2,format=qcow2,bus=virtio \
--network bridge=virbr0,model=virtio \
--os-variant=rhel10.0 \
--graphics spice \
--location=$vmISOlocation \
--initrd-inject '/home/'$USER'/github/Redhat-RHCSA-study-materials/kickstart/ksSrv.cfg' \
--extra-args 'inst.ks=file:/ksSrv.cfg'
