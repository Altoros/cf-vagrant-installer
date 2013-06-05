ROOT_FS = "/var/warden/rootfs"
ROOT_FS_URL = "http://cfstacks.s3.amazonaws.com/lucid64.dev.tgz"

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
