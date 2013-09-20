# -*- mode: ruby -*-
# vim: set ft=ruby sw=2 :

Vagrant.configure("2") do |config|
  config.omnibus.chef_version = "11.4.0"

  config.vm.define "cf-install"
  config.vm.box = "precise64"
  config.vm.hostname = "cf"
  config.vm.network :private_network, ip: "192.168.12.34"

  config.vm.provider :virtualbox do |v, override|
    override.vm.box_url = "http://files.vagrantup.com/precise64.box"
    v.customize ["modifyvm", :id, "--memory", 2 * 1024]
    v.customize ["modifyvm", :id, "--cpus", "2"]
  end

  config.vm.provider :vmware_fusion do |v, override|
    override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"
    v.vmx['memsize'] = 2 * 1024
  end

  config.vm.provider :vmware_workstation do |v, override|
    override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"
    v.vmx['memsize'] = 2 * 1024
  end

  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe 'cloudfoundry::vagrant-provision-start'

    chef.add_recipe 'apt::default'
    chef.add_recipe 'git'
    chef.add_recipe 'chef-golang'
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'rbenv::user'
    chef.add_recipe 'java::openjdk'
    chef.add_recipe 'sqlite'
    chef.add_recipe 'mysql::server'
    chef.add_recipe 'postgresql::server'

    chef.add_recipe 'rbenv-alias'
    chef.add_recipe 'rbenv-sudo'
    chef.add_recipe 'cloudfoundry::warden'
    chef.add_recipe 'cloudfoundry::dea'
    chef.add_recipe 'cloudfoundry::uaa'
    chef.add_recipe 'cloudfoundry::cf_bootstrap'

    chef.add_recipe 'cloudfoundry::vagrant-provision-end'

    chef.json = {
      'rbenv' => {
        'user_installs' => [ {
          'user' => 'vagrant',
          'global' => '1.9.3-p392',
          'rubies' => [ '1.9.3-p392' ],
          'gems' => {
            '1.9.3-p392' => [
              { 'name' => 'bundler' }
            ]
          },
        } ]
      },
      'rbenv-alias' => {
        'user_rubies' => [ {
          'user' => 'vagrant',
          'installed' => '1.9.3-p392',
          'alias' => '1.9.3'
        } ]
      },
      'mysql' => {
        'server_root_password' => '',
        'server_repl_password' => '',
        'server_debian_password' => ''
      },
      'postgresql' => {
        'password' => {
          'postgres' => ''
        }
      }
    }
  end
end
