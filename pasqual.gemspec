# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pasqual/version'

Gem::Specification.new do |spec|
  spec.name          = "pasqual"
  spec.version       = Pasqual::VERSION
  spec.authors       = ["Derek Kastner"]
  spec.email         = ["dkastner@gmail.com"]
  spec.summary       = %q{Interface easily with postgres CLI tools}
  spec.description   = %q{Shortcuts for postgres commands, with option to use ENV-configured conenction URLs}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "childprocess", "~> 0.5"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0.0"
end
