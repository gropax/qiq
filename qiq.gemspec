# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qiq/version'

Gem::Specification.new do |spec|
  spec.name          = "qiq"
  spec.version       = Qiq::VERSION
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
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "commander"
  spec.add_runtime_dependency "activeresource"
end
