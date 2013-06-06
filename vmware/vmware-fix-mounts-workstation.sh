#!/bin/bash

function echoerr
{
  echo "$@" 1>&2
}

hash vmrun > /dev/null || { 
  echoerr "vmrun command not available!"
  exit 1
}

if [[ ! -s Vagrantfile ]]
then
  echoerr "Script must be run from same directory as Vagrantfile!"
  exit 1
fi

precise_vmx=$(vmrun list | fgrep cf-install)
if [[ ! -s $precise_vmx ]]
then
  echoerr "Can't find expected VM or VM not running: cf-install"
  exit 1
fi

vagrant_dir=$(dirname $(readlink -f Vagrantfile))
echo "Vagrantfile directory: '$vagrant_dir'"

echo -n 'Removing vagrant shared folders...'
vmrun -T ws removeSharedFolder "$precise_vmx" '/vagrant'
vmrun -T ws removeSharedFolder "$precise_vmx" 'vagrant'
echo 'Done'

echo -n "Adding /vagrant shared folder (host dir: '$vagrant_dir')..."
vmrun -T ws addSharedFolder "$precise_vmx" '/vagrant' "$vagrant_dir"
echo 'Done'

sleep 5

echo -n "Creating shared folder mount point..."
vmrun -T ws -gu vagrant -gp vagrant runScriptInGuest "$precise_vmx" \
  /bin/bash 'sudo rm -f /vagrant; sudo mkdir /vagrant; sudo umount /vagrant; sudo mount -t vmhgfs -o rw,noatime,nodev '\''.host:/!%vagrant'\'' /vagrant'
echo 'Done'
