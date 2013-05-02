git "/cf-deploy/cloud_controller_ng" do
  repository "https://github.com/cloudfoundry/cloud_controller_ng.git"
  revision "db2de6f2f0c26858cccfa55a544dc3a2500f1173"
  action :sync
end

execute "install cloud_controller_ng gems" do
  cwd "/cf-deploy/cloud_controller_ng"
  command "bundle install"
  action :run
end

execute "run db:migrate" do
  cwd "/cf-deploy/cloud_controller_ng"
  command "bundle exec rake db:migrate"
  action :run
end
