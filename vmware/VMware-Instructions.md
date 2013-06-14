# Working With VMware

The following steps have been tested with VMware Workstation 9 and VMware Fusion 4.0.3.

## Downloading The Vagrant Box
Use `vagrant` to download and make available the `precise64_vmware` box:

> `$ vagrant box add precise64 http://files.vagrantup.com/precise64_vmware.box --provider=vmware_fusion`

Once downloaded, the box will be available here: `~/.vagrant.d/boxes/precise64/vmware_fusion`

> ### Modifying The precise64_vmware Box To Work With Workstation
> **Note: this does not apply to VMware Fusion - if you are on a Mac, move to the next section.**

> Because the Vagrant provider for VMware Workstation relies on a convention to determine the provider for installed boxes and the original box was built for the vmware_fusion provider, we need to make a modification to the downloaded box for it to work correctly. Specifically, you need to rename (or copy if you wish) the `~/.vagrant.d/boxes/precise64/vmware_fusion` directory to `~/.vagrant.d/boxes/precise64/vmware_workstation`:

> I.e. do one of the following:
> <ul>
> <li>`$ mv -f ~/.vagrant.d/boxes/precise64/vmware_fusion ~/.vagrant.d/boxes/precise64/vmware_workstation`</li>
> <li>`$ cp -r ~/.vagrant.d/boxes/precise64/vmware_fusion ~/.vagrant.d/boxes/precise64/vmware_workstation`</li>
> </ul>

## Modifying The Box To Work With The Vagrant Cloud Foundry Installer
Unfortunately, the `precise64_vmware` box is based on a different Ubuntu 12.04 release than the `precise64` box: 

#### precise64
> vagrant@precise64:~$ uname -a
>
> Linux precise64 3.2.0-**23-generic** #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

#### precise64_vmware
> vagrant@precise64:~$  uname -a
>
> Linux precise64 3.2.0-**29-virtual** #46-Ubuntu SMP Fri Jul 27 17:23:50 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

As a result, we need to perform a few more steps to ensure `quota` can do its job effectively. You must spin up this box and run the provided setup scripts to install the missing requirements.

### Copy Scripts To The VM
1. Start the VM:
    - Workstation: `$ vmrun -T ws start ~/.vagrant.d/boxes/precise64/vmware_workstation/precise64.vmx nogui`
    -  Fusion: `$ /Applications/VMware\ Fusion.app/Contents/Library/vmrun -T ws start ~/.vagrant.d/boxes/precise64/vmware_fusion/precise64.vmx nogui`
2. Confirm the VM is running:
    - Workstation: `$ vmrun list`
    - Fusion: ` $ /Applications/VMware\ Fusion.app/Contents/Library/vmrun list`
3. Ensure you are in the correct directory (vmware): `$ cd vmware`
4. Copy the setup scripts to the box:
    - Workstation: `$ ./vmware-copy-scripts-workstation.sh`
    - Fusion: `$ /vmware-copy-scripts-fusion.sh`

### Run Scripts On The VM
1. Open the VMware GUI, go to the console
2. Log in (username: `vagrant`, password: `vagrant`)
3. Run `sudo ~/vmware-setup1.sh` This script will reboot the box upon completion.
4. Once rebooted, log in again via the console and run `sudo ~/vmware-setup2.sh`. This script will shut the box down.

## Resume Normal Provisioning Process
Now you can follow the documented process to bring the Cloud Foundry environment up using Vagrant. One detail - be sure to use the `vmware_workstation` or `vmware_fusion` provider:

- Workstation: `$ vagrant up --provider=vmware_workstation`
- Fusion: `$ vagrant up --provider=vmware_fusion`

## Cleaning And Starting Up
Once completed, and you have run `rake cf:bootstrap` in the VM, use the following script on the host to "fix" the shared folder mount:

```
$ ./vmware/vmware-fix-mounts-workstation.sh
```
When you are back on the guest VM, you will then want to run the foreman script *instead of* ./start.sh

```
$ foreman start
```

> At this point you may have running processes on ports that the foreman generated processes want to utilize.
> It is advisable to disable the cf-ng scripts in order to prevent this, and then restart the guest VM.

> ```
> $(precise64) sudo rm /etc/init/cf-ng*
> $(precise64) sudo shutdown -r 'now'
> ```

> Note that you will have to rerun the mount fixing scripts every time you reboot the machine. From your host terminal, rerun the mount fix scripts.

> ```
> $(host) ./vmware/vmware-fix-mounts-workstation.sh
> ```
> When the VM has booted back up, log back in and try the foreman scripts again.


