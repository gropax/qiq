$LOAD_PATH << File.expand_path("../../../lib", __FILE__)

require 'aruba/cucumber'
require 'aruba/in_process'
require 'qiq/runner'

Aruba::InProcess.main_class = Qiq::Runner
Aruba.process = Aruba::InProcess

require 'webmock/cucumber'
WebMock.disable_net_connect!(allow_localhost: true)

require 'qiq'
