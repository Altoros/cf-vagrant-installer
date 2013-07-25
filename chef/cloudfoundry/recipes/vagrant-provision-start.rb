
# Setup sudo to be consistent with vbox
group "admin" do
    action :create
    gid "999"
    members "vagrant"
    append true
end

ruby_block "update defaults" do
    block do
        file = Chef::Util::FileEdit.new("/etc/sudoers")
        file.insert_line_if_no_match(/^Defaults\s+(.*)?exempt_group=.*/, "Defaults\texempt_group=admin")
        file.write_file
    end
end

vagrant_target = File.readlink("/vagrant")
vagrant_device = '.host:/' + File.basename(vagrant_target)

# Delete the vagrant link if vmware guest
link "/vagrant" do
    action :delete
    only_if { node[:virtualization][:system] == "vmware" }
    only_if { node[:virtualization][:role] == "guest" }
    only_if { ["/mnt/hgfs/!%vagrant", "/mnt/hgfs/-vagrant"].include?(vagrant_target) }
    notifies :create, "directory[/vagrant]", :immediately
    notifies :mount, "mount[/vagrant]", :immediately
end

# Create the mount point
directory "/vagrant" do
    owner "root"
    group "root"
    mode 00644
    action :nothing
end

# Mount the file system
mount "/vagrant" do
    device vagrant_device
    fstype "vmhgfs"
    options "rw,noatime,nodev"
    action :nothing
end
