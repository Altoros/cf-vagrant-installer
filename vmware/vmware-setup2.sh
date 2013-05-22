#!/usr/bin/env bash

set -o errexit
set -o nounset

vmware-config-tools.pl -d
quotaoff -a
quotacheck -avugm
quotaon -a
shutdown -h now
