#!/usr/bin/env bash

set -o errexit
set -o nounset

precise_vmx=$(/Applications/VMware\ Fusion.app/Contents/Library/vmrun list | fgrep precise64.vmx)

/Applications/VMware\ Fusion.app/Contents/Library/vmrun -gu vagrant -gp vagrant copyFileFromHostToGuest "$precise_vmx" vmware-setup1.sh /tmp/vmware-setup1.sh
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -gu vagrant -gp vagrant copyFileFromHostToGuest "$precise_vmx" vmware-setup2.sh /tmp/vmware-setup2.sh
