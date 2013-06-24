require 'rubygems'
require 'sinatra'

get '/' do
  host = ENV['VCAP_APP_HOST']
  port = ENV['VCAP_APP_PORT']
  "\nHello from #{host}:#{port}!\n"
end
