
bash "emit provision complete" do
    user "root"
    cwd "/vagrant"
    code <<-END_OF_SCRIPT
        /sbin/initctl emit --no-wait vagrant-provisioner-complete
    END_OF_SCRIPT
end
