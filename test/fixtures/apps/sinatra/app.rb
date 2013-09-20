require 'rubygems'
require 'sinatra'

get '/' do
  host = ENV['VCAP_APP_HOST']
  port = ENV['VCAP_APP_PORT']
  <<-EOS
  <h3>Sinatra Test app for CF Vagrant Installer</h3>
      Hello from #{host}:#{port}! <br/>
  <hr>
  <h4> Environment variables </h4>
TMPDIR= #{ENV['TMPDIR']} <br/>
VCAP_APP_PORT= #{ENV['VCAP_APP_PORT']} <br/>
VCAP_CONSOLE_IP= #{ENV['VCAP_CONSOLE_IP']} <br/>
USER= #{ENV['USER']} <br/>
VCAP_APPLICATION= #{ENV['VCAP_APPLICATION']} <br/>
RACK_ENV= #{ENV['RACK_ENV']} <br/>
PATH= #{ENV['PATH']} <br/>
PWD= #{ENV['PWD']} <br/>
LANG= #{ENV['LANG']} <br/>
VCAP_SERVICES= #{ENV['VCAP_SERVICES']} <br/>
HOME= #{ENV['HOME']} <br/>
SHLVL= #{ENV['SHLVL']} <br/>
GEM_PATH= #{ENV['GEM_PATH']} <br/>
PORT= #{ENV['PORT']} <br/>
VCAP_APP_HOST= #{ENV['VCAP_APP_HOST']} <br/>
MEMORY_LIMIT= #{ENV['MEMORY_LIMIT']} <br/>
VCAP_CONSOLE_PORT= #{ENV['VCAP_CONSOLE_PORT']} <br/>
  EOS
end
