require 'rake'

namespace :host do

  desc "Initialize repos and vagrant vm"
  task :bootstrap => :update_git_submodules

  desc "Init git submodules and clone required repos"
  task :update_git_submodules do
    puts "==> Init Git submodules"
    system "git submodule update --init --recursive"
  end

end

namespace :cf do
  # -------------------------------------------------------------
  # Guest tasks

  def root_path
    File.expand_path("../", __FILE__)
  end

  def path(component)
    File.expand_path("../#{component}", __FILE__)
  end

  def bundle_install component_path
    puts "==> Runing bundle install at #{component_path}"
    Dir.chdir component_path
    system "bundle install"
  end

  def cf_ruby_components
    %w(warden/warden cloud_controller_ng dea_ng health_manager)
  end

  def cf_components
    cf_ruby_components + %w(uaa gorouter)
  end

  desc "bootstrap all cf components"
  task :bootstrap => [:copy_custom_conf_files,
        :bundle_install, :init_uaa,
        :init_cloud_controller_ng, :init_gorouter, :setup_warden ]

  desc "Install required gems for all ruby components"
  task :bundle_install do
    cf_ruby_components.each{|c| bundle_install path(c)}
    system "gem install cf --no-ri --no-rdoc"
    system "gem install foreman --no-ri --no-rdoc"
    system "rbenv rehash"
  end

  desc "Init cloud_controller_ng database - Erases it if exists"
  task :init_cloud_controller_ng do
    puts "Initializing cloud_controller_ng database."
    Dir.chdir root_path
    system "rm db/cloud_controller.db"
    Dir.chdir root_path + '/cloud_controller_ng'
    system "bundle exec rake db:migrate"
  end

  desc "Init gorouter"
  task :init_gorouter do
    Dir.chdir root_path + '/gorouter'
    system "./bin/go install router/router"
  end

  desc "Init uaa"
  task :init_uaa do
    Dir.chdir root_path + '/uaa'
    system "mvn package -DskipTests"
  end

  desc "copy custom config files"
  task :copy_custom_conf_files do
    cf_components.each do |c|
      cmd = "cp #{root_path}/custom_config_files/#{c}/*.yml #{root_path}/#{c}/config/"
      puts "==> Copying #{c} config file"
      puts "==> #{cmd}"
      system cmd
    end
  end

  desc "set up warden"
  task :setup_warden do
    puts "==> Warden setup"
    Dir.chdir root_path + '/warden/warden'
    system "rbenv sudo bundle exec rake setup:bin[config/test_vm.yml]"
  end

  desc "Set target, login and create organization and spaces. CF must be up and running"
  task :init_cf_cli do
    puts "==> Initializing cf CLI"
    system "#{root_path}/bin/init-cf-cli"
    puts "\n\nNow you can try to push the example app, like this:"
    puts ""
    puts "> cd /vagrant/sinatra-test-app"
    puts "> cf push"
  end
end
