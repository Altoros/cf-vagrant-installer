git "/cf-deploy/dea_ng" do
  repository "https://github.com/cloudfoundry/dea_ng.git"
  revision "e9562f472da4dc0341fe321aa02d103dc105a6f5"
  action :sync
end

execute "dea submodules update" do
  cwd "/cf-deploy/dea_ng"
  command "git submodule update --init"
  action :run
end

execute "install dea gems" do
  cwd "/cf-deploy/dea_ng"
  command "bundle install"
  action :run
end
