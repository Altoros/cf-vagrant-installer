# Working With VMware

The following steps have been tested with VMware Workstation 9 and VMware Fusion 4.0.3.

## Downloading The Vagrant Box
Use `vagrant` to download and make available the `precise64_vmware` box:

> `$ vagrant box add precise64 http://files.vagrantup.com/precise64_vmware.box --provider=vmware_fusion`

Once downloaded, the box will be available here: `~/.vagrant.d/boxes/precise64/vmware_fusion`

> ### Modifying The precise64_vmware Box To Work With Workstation
> **Note: this does not apply to VMware Fusion - if you are on a Mac, move to the next section.**

> Because the Vagrant provider for VMware Workstation relies on a convention to determine the provider for installed boxes and the original box was built for the vmware_fusion provider, we need to make a modification to the downloaded box for it to work correctly. Specifically, you need to rename (or copy if you wish) the `~/.vagrant.d/boxes/precise64/vmware_fusion` directory to `~/.vagrant.d/boxes/precise64/vmware_workstation`:

> i.e. do one of the following:
> <ul>
> <li>`$ mv -f ~/.vagrant.d/boxes/precise64/vmware_fusion ~/.vagrant.d/boxes/precise64/vmware_workstation`</li>
> <li>`$ cp -r ~/.vagrant.d/boxes/precise64/vmware_fusion ~/.vagrant.d/boxes/precise64/vmware_workstation`</li>
> </ul>

## Initiate the Normal Provisioning Process
Now you can follow the documented process to bring the Cloud Foundry environment up using Vagrant. One detail - be sure to use the `vmware_workstation` or `vmware_fusion` provider:

- Workstation: `$ vagrant up --provider=vmware_workstation`
- Fusion: `$ vagrant up --provider=vmware_fusion`

