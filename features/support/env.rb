$LOAD_PATH << File.expand_path("../../../lib", __FILE__)

require 'aruba/cucumber'

require 'webmock/cucumber'
WebMock.disable_net_connect!(allow_localhost: true)

require 'qiq'
