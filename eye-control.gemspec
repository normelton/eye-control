# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eye-control/version'

Gem::Specification.new do |spec|
  spec.name          = "eye-control"
  spec.version       = EyeControl::VERSION
  spec.authors       = ["Norman Elton"]
  spec.email         = ["normelton@gmail.com"]
  spec.description   = "A plugin for eye that manages process state across multiple servers"
  spec.summary       = "A plugin for eye that manages process state across multiple servers"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "eye", ">= 0.5.2"
  spec.add_dependency "celluloid-redis"
end
