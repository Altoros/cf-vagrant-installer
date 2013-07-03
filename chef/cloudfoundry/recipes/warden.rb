ROOT_FS = "/var/warden/rootfs"
ROOT_FS_URL = "http://cfstacks.s3.amazonaws.com/lucid64.dev.tgz"

if ["debian", "ubuntu"].include?(node["platform"])
  if node["kernel"]["release"].end_with? "virtual"
    package "linux-image-extra" do
      package_name "linux-image-extra-#{node['kernel']['release']}"
      action :install
    end
  end
end

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
