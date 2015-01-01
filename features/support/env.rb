$LOAD_PATH << File.expand_path("../../../lib", __FILE__)

require 'pry'

require 'aruba/cucumber'
require 'aruba/in_process'
require 'qiq/runner'

Before('@in-process') do
  Aruba::InProcess.main_class = Qiq::Runner
  Aruba.process = Aruba::InProcess
end

Before('~@in-process') do
  Aruba.process = Aruba::SpawnProcess
end


require 'webmock/cucumber'
WebMock.disable_net_connect!(allow_localhost: true)

require 'qiq'
