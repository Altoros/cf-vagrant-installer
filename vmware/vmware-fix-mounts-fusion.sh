#!/bin/bash

function echoerr
{
  echo "$@" 1>&2
}

vmrun_cmd="/Applications/VMware Fusion.app/Contents/Library/vmrun"

hash $vmrun_cmd > /dev/null || { 
  echoerr "vmrun command not available!"
  exit 1
}

if [[ ! -s Vagrantfile ]]
then
  echoerr "Script must be run from same directory as Vagrantfile!"
  exit 1
fi

precise_vmx=$("$vmrun_cmd" list | fgrep cf-install)
if [[ ! -s $precise_vmx ]]
then
  echoerr "Can't find expected VM or VM not running: cf-install"
  exit 1
fi

vagrant_dir=$(dirname $(vmware/readlinkscript.sh Vagrantfile))
echo "Vagrantfile directory: '$vagrant_dir'"

echo -n 'Removing vagrant shared folders...'
echo -n 'Trying to remove /vagrant: '
"$vmrun_cmd" -T ws removeSharedFolder "$precise_vmx" '/vagrant'
echo -n 'Trying to remove vagrant: '
"$vmrun_cmd" -T ws removeSharedFolder "$precise_vmx" 'vagrant'
echo 'Done'

echo -n "Adding /vagrant shared folder (host dir: '$vagrant_dir')..."
"$vmrun_cmd" -T ws addSharedFolder "$precise_vmx" '/vagrant' "$vagrant_dir"
echo 'Done'

sleep 5

echo -n "Creating shared folder mount point..."
"$vmrun_cmd" -T ws -gu vagrant -gp vagrant runScriptInGuest "$precise_vmx" \
  /bin/bash 'sudo rm -f /vagrant; sudo mkdir /vagrant; sudo umount /vagrant; sudo mount -t vmhgfs -o rw,noatime,nodev '\''.host:/!%vagrant'\'' /vagrant'
echo 'Done'
