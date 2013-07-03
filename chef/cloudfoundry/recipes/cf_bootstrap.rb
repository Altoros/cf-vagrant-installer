CF_UPSTART_FILE = "/etc/init/cf-ng.conf"

execute "run rake cf:bootstrap" do
  command <<-BASH
    su - vagrant -c /vagrant/bin/cf_bootstrap
  BASH
  not_if { ::File.exists?(CF_UPSTART_FILE) }
end
