# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qiq/client/version'

Gem::Specification.new do |spec|
  spec.name          = "qiq-client"
  spec.version       = Qiq::Client::VERSION
  spec.authors       = ["Maxime Laudrin"]
  spec.email         = ["maximedelaudrin@gmail.com"]
  spec.summary       = %q{Manage note, with tagging and buffering support.}
  #spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "webmock"

  #spec.add_runtime_dependency "commander"
end
