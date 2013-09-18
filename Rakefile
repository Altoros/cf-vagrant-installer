require 'rake'
require 'rake/testtask'
require 'fileutils'

task :default => :test

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
end

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
  DEFAULT_BUILDPACKS = %w(ruby java nodejs)
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

  def delete_cc_db!
    cc_db_file = "#{root_path}/db/cloud_controller.db"
    File.delete cc_db_file if File.exists? cc_db_file
  end

  desc "bootstrap all cf components"
  task :bootstrap => [ :bundle_install,
                       :init_uaa,
                       :init_dea,
                       :init_cloud_controller_ng,
                       :init_gorouter,
                       :setup_warden,
                       :setup_custom_buildpacks,
                       :start_cf,
                       :instructions
                     ]

  desc "Install required gems for all ruby components"
  task :bundle_install do
    cf_ruby_components.each{|c| bundle_install path(c)}
    system "gem install cf --no-ri --no-rdoc"
    system "rbenv rehash"
  end

  desc "Init cloud_controller_ng database - Erases it if exists"
  task :init_cloud_controller_ng do
    puts "==> Deleting cloud_controller_ng database."
    delete_cc_db!
    puts "==> Runing migrations cloud_controller_ng database."
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

  desc "Init dea"
  task :init_dea do
    Dir.chdir root_path + '/dea_ng'
    system "bundle exec rake dir_server:install"
  end

  desc "set up warden"
  task :setup_warden do
    puts "==> Warden setup"
    Dir.chdir root_path + '/warden/warden'
    system "bundle exec rake setup:bin[/vagrant/custom_config_files/warden/warden/test_vm.yml]"
  end

  desc "Set up custom buildpacks"
  task :setup_custom_buildpacks do
    source_dir = 'custom-buildpacks'
    target_dir = path('dea_ng/buildpacks/vendor')

    custom_buildpacks = Dir.glob(File.join(source_dir, '*')).
      find_all{ |p| File.directory?(p) }.
      map{ |p| File.basename(p) }
    target_buildpacks = Dir.glob(File.join(target_dir, '*')).
      find_all{ |p| File.directory?(p) }.
      map{ |p| File.basename(p) }
    # Cleaning up old buildpacks
    (target_buildpacks - DEFAULT_BUILDPACKS).each do |b|
      puts "Removing #{b} buildpack"
      FileUtils.rm_rf(File.join(target_dir, b))
    end

    custom_buildpacks.each do |b|
      puts "Deploying custom buildpack #{b}"
      source = File.join(source_dir, b)
      target = File.join(target_dir, b)
      FileUtils.cp_r(source, target)
    end
  end

  desc "Set target, login and create organization and spaces. CF must be up and running"
  task :init_cf_cli do
    puts "==> Initializing cf CLI"
    system "#{root_path}/bin/init-cf-cli"
  end

  desc "Set up Upstart init scripts"
  task :copy_upstart_init_scripts do
    puts "==> Copying Cloud Foundry upstart config files..."
    system "sudo cp /vagrant/init/*.conf /etc/init"
  end

  desc "Run cf upstart job"
  task :start_cf => :copy_upstart_init_scripts do
    puts "==> Starting cf upstart Job"
    system "sudo initctl start cf"
  end

  desc "Print instructions"
  task :instructions do
msg = <<-EOS

*** Running Cloud Foundry and first steps ***

- Run Cloud Foundry:
  $ sudo initctl start cf

- Wait until UAA finishes starting. You can check the status by running:
  $ tail -f /vagrant/logs/uaa.log

- Initialize the cf CLI and create a default organization, space, etc:
  $ rake cf:init_cf_cli"

- Push a very simple ruby sinatra app:
  $ cd /vagrant/test-apps/sinatra-test-app/
  $ cf push   (follow the defaults)

- Test it:
  $ curl -v hello.vcap.me  (It should print 'Hello!')

EOS
puts msg
  end
end
