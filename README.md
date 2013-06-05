This project provides a mechanism to automate several tasks to be able to set up a Vagrant VM with the following V2 (NG) Cloud Foundry components:
* NATS
* Warden
* DEA
  * Directory Server
  * File Server
* Cloud Controller
* Gorouter
* UAA
* Health Manager

REQUIREMENTS
--
* Vagrant version 1.2 or higher. Vagrant can be downloaded from http://www.vagrantup.com/. After installing, make sure it is available with the following command: 

```
vagrant --version
```

* Berkshelf plugin for Vagrant. After installing Vagrant, run this command to get the plugin: 

```
vagrant plugin install vagrant-berkshelf
```

* Ruby 1.9.3

INSTALLATION
--
Installation requires three steps in two phases (first on the host machine, then on the guest VM).

* Host

Set up the project for Vagrant.

```
# clone the repo
git clone https://github.com/Altoros/cf-vagrant-installer.git
cd cf-vagrant-installer
# Set up host computer
rake host:bootstrap
```

Initialize the Vagrant VM using the default VirtualBox provider. 

```
vagrant up
```

Alternatively, you can use a different Vagrant provider such as the VMware Fusion provider. See the [Vagrant documentation](http://docs.vagrantup.com/v2/providers/index.html) for information on installing and using providers.  

```
vagrant up --provider=vmware_fusion
```

* Guest (inside Vagrant VM)

Shell into the guest VM and run the next step of the installation. 

```
vagrant ssh
cd /vagrant
rake cf:bootstrap
```

RUNNING CF
--

```
# shell into the VM if you are not already there
vagrant ssh

cd /vagrant
./start.sh

# Also, to stop:
./stop.sh

```

There is also a foreman alternative (http://ddollar.github.io/foreman/) which will print every single log into the console
```
foreman start
```

Note: UAA requires lot of dependencies which will download only once.

TEST YOUR CF
--
(this has to be done inside the VM)
* Set up your PaaS account

```
cd /vagrant
rake cf:init_cf_cli
```

* Push a very simple sinatra application

```
cd /vagrant/sinatra-test-app
cf push
Name> my_app
Instances> 1
Custom startup command> none
Memory Limit> 256M
Subdomain> my_app
Domain> vcap.me
Create services for application?> n
Save configuration?> n
```

Expected output:

```
Uploading my_app... OK
Starting my_app... OK
-----> Downloaded app package (4.0K)
Installing ruby.
-----> Using Ruby version: ruby-1.9.2
-----> Installing dependencies using Bundler version 1.3.2
       Running: bundle install --without development:test --path vendor/bundle --binstubs vendor/bundle/bin --deployment
       Fetching gem metadata from http://rubygems.org/..........
       Fetching gem metadata from http://rubygems.org/..
       Installing rack (1.5.1)
       Installing rack-protection (1.3.2)
       Installing tilt (1.3.3)
       Installing sinatra (1.3.4)
       Using bundler (1.3.2)
       Your bundle is complete! It was installed into ./vendor/bundle
       Cleaning up the bundler cache.
-----> Uploading staged droplet (21M)
Checking my_app...
  1/1 instances: 1 running
OK
```

Check if the app is running and working ok:

```
curl my_app.vcap.me
Hello!
```

Use "cf apps" command to list the apps you pushed:
```
cf apps
Getting applications in myspace... OK

name    status    usage     url          
my_app   running   1 x 64M   my_app.vcap.me
```


Collaborate
--
You are welcome to contribute via [pull request](https://help.github.com/articles/using-pull-requests)