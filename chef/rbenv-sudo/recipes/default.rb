#
# Cookbook Name:: rbenv-sudo
# Recipe:: default
#

Array(node['rbenv-alias']['user_rubies']).each do |ruby|
  directory "/home/#{ruby['user']}/.rbenv/plugins" do
    owner ruby['user']
    group ruby['user']
    mode "0755"
    action :create
  end
end


Array(node['rbenv-alias']['user_rubies']).each do |ruby|
  git "/home/#{ruby['user']}/.rbenv/plugins/rbenv-sudo" do
    repository "git://github.com/dcarley/rbenv-sudo.git"
    reference "master"
    action :sync
  end
end
