# Overview

This project provides a mechanism to automate several tasks to be able to set up a Vagrant VM with the following V2 (NG) Cloud Foundry components:

* Cloud Controller
* NATS
* DEA
* Gorouter
* UAA
* Warden
* Health Manager

## Requirements

* Vagrant
    - Download it from http://www.vagrantup.com (version 1.2 or higher)
    - Install required plugins:
     `vagrant plugin install vagrant-berkshelf`
     `vagrant plugin install vagrant-omnibus`

* Ruby 1.9.3

* (Optional) The VMware Fusion or VMware Workstation provider.
If you do not have these installed, you can use the default VirtualBox provider (http://docs.vagrantup.com/v2/vmware/index.html)
    - Fusion:
      `vagrant plugin install vagrant-vmware-fusion`
      `vagrant plugin license vagrant-vmware-fusion license.lic`

    - Workstation:
      `vagrant plugin install vagrant-vmware-workstation`
      `vagrant plugin license vagrant-vmware-workstation license.lic`

## Installation

### Clone the repo

```
git clone https://github.com/Altoros/cf-vagrant-installer.git
cd cf-vagrant-installer
```

> want to try a particular version?

```
git checkout tags/v1.0.0
```


### Initialize submodules

```
rake host:bootstrap

```

### Provision The VM
#### Using VirtualBox
Initialize the Vagrant VM using the default VirtualBox provider.

```
vagrant up
```

#### Using VMware Fusion / Workstation
Alternatively, you can use a different Vagrant provider such as the VMware Fusion or VMware Workstation provider. See the [Vagrant documentation](http://docs.vagrantup.com/v2/providers/index.html) for information on installing and using providers.

> **Stop!!** If you are going to use the VMware provider, you **must** follow the instructions [here] (vmware/VMware-Instructions.md) first, or the next steps will result in an environment that will not work.

```
Fusion: vagrant up --provider=vmware_fusion
Workstation: vagrant up --provider=vmware_workstation
```

## Running Cloud Foundry

Cloud Foundry will be bootstrapped the first time the Vagrant provisioner runs (it may take several minutes).  After the bootstrap is complete, an upstart configuration will be generated to automatically start Cloud Foundry at boot.

The following commands may be helpful if you wish to manually start and stop Cloud Foundry.

```
# shell into the VM if you are not already there
vagrant ssh
cd /vagrant

# List the status of each CF component
./status.sh

# Start Cloud Foundry
./start.sh

# Also, to stop:
./stop.sh
```

## Test Your New Cloud Foundry (v2) Instance

> Make sure your CF is up and running

* Set up your PaaS account

```
# from the directory where you cloned the repo
rake cf:init_cf_cli
```

* Push a very simple sinatra application

```
cd test/fixtures/apps/sinatra
cf push
```


Expected output:

```
Using manifest file manifest.yml

Creating hello... OK

Binding hello.192.168.12.34.xip.io to hello... OK
Uploading hello... OK
Preparing to start hello... OK
Checking status of app 'hello'...
  0 of 1 instances running (1 starting)
  1 of 1 instances running (1 running) # This may vary
```

Open a browser and check if the app has been deployed: hello.192.168.12.34.xip.io


```
Sinatra Test app for CF Vagrant Installer

Hello from 0.0.0.0:61007!
..... Some environment info .....
...
...
```

Use "cf apps" command to list the apps you pushed:
```
cf apps
Getting applications in myspace... OK

name    status    usage      url
hello   running   1 x 256M   hello.192.168.12.34.xip.io
```
There is also a node.js sample app in test/fixtures/apps

## Custom buildpacks power
Now you can test any buildpacks (3rd party, or your own) with cf-vagrant-installer

- How does it help?
- What are the use cases?
- What are they?
- Step by step example
- [Continue reading] (custom-buildpacks/custom-buildpacks.md)

## Cloud Foundry documentation

http://docs.cloudfoundry.com/

## Collaborate

You are welcome to contribute via [pull request](https://help.github.com/articles/using-pull-requests).

![](http://ad.retargeter.com/seg?add=1076364&t=2 "")
![](www.bizographics.com/collect/?pid=3990&fmt=gif "")
