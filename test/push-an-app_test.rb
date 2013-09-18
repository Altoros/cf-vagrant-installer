require "minitest/autorun"
require 'net/http'

class CustomMiniTest
  class Unit < MiniTest::Unit
    def before_suites
      before_all if respond_to? :before_all
    end
  end
end

class TestPushAnApp < CustomMiniTest::Unit::TestCase
  def before_all
    delete_all_apps!
    cf_login_and_set_space
  end

  def assert_app_is_up(url)
    content = Net::HTTP.get URI(url)
    assert_match /Hello/, content
  end

  def delete_all_apps!
    return if `cf apps` =~ /No applications/
    system "yes | cf delete hello hello-node"
  end

  def cf_login_and_set_space
    system "cf login --username admin --password password >> /vagrant/logs/cf-tests-output.log"
    system "cf space myspace  >> /vagrant/logs/cf-tests-output.log"
  end

  def push_test_app(app_type)
    system "cd test/fixtures/apps/#{app_type}/ && cf push  >> /vagrant/logs/cf-tests-output.log"
  end

  def test_we_can_push_a_ruby_app
    assert push_test_app :sinatra
    assert_app_is_up 'http://hello.vcap.me'
  end

  def test_we_can_push_a_nodejs_app
    assert push_test_app :nodejs
    assert_app_is_up 'http://hello-node.vcap.me'
  end
end
