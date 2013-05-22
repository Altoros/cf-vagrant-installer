WARDEN_PATH = "/vagrant/warden/warden"
ROOT_FS = "/var/warden/rootfs"
ROOT_FS_URL = "http://cfstacks.s3.amazonaws.com/lucid64.dev.tgz"
OLD_CONFIG_FILE_PATH = "#{WARDEN_PATH}/config/linux.yml"
NEW_CONFIG_FILE_PATH = "#{WARDEN_PATH}/config/test_vm.yml"

package "quota" do
  action :install
end

package "iptables" do
  action :install
end

package "apparmor" do
  action :remove
end

execute "remove remove all remnants of apparmor" do
  command "sudo dpkg --purge apparmor"
end

ruby_block "configure warden to put its rootfs outside of /tmp" do
  block do
    require "yaml"
    config = YAML.load_file(OLD_CONFIG_FILE_PATH)
    config["server"]["container_rootfs_path"] = ROOT_FS
    File.open(NEW_CONFIG_FILE_PATH, 'w') { |f| YAML.dump(config, f) }
  end
  action :create
end

execute "download warden rootfs from s3" do
  command <<-BASH
    rm -rf #{ROOT_FS}
    mkdir -p #{ROOT_FS}
    curl -s #{ROOT_FS_URL} | tar xzf - -C #{ROOT_FS}
  BASH
  not_if { ::File.exists?(ROOT_FS)}
end

execute "copy resolv.conf from outside container" do
  command "cp /etc/resolv.conf #{ROOT_FS}/etc/resolv.conf"
end
