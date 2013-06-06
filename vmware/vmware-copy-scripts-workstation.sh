#!/usr/bin/env bash

set -o errexit
set -o nounset

precise_vmx=$(vmrun list | fgrep precise64.vmx)

vmrun -gu vagrant -gp vagrant copyFileFromHostToGuest "$precise_vmx" vmware-setup1.sh /home/vagrant/vmware-setup1.sh
vmrun -gu vagrant -gp vagrant copyFileFromHostToGuest "$precise_vmx" vmware-setup2.sh /home/vagrant/vmware-setup2.sh
