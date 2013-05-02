git "/cf-deploy/uaa" do
  repository "https://github.com/cloudfoundry/uaa.git"
  revision "c4c413412572a7979d7a88314b3a17274950fa72"
  action :sync
end

execute "install java uaa packages" do
  cwd "/cf-deploy/uaa"
  command "mvn clean install -Dmaven.test.skip=true"
  action :run
end

execute "uaa - generating packages" do
  cwd "/cf-deploy/uaa"
  command "mvn package -Dmaven.test.skip=true"
  action :run
end
