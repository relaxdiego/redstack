# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redstack/version'

Gem::Specification.new do |spec|
  spec.name          = "redstack"
  spec.version       = RedStack::VERSION
  spec.authors       = ["Mark Maglana"]
  spec.email         = ["mmaglana@gmail.com"]
  spec.description   = %q{A Ruby binding for the OpenStack API}
  spec.summary       = %q{A Ruby binding for the OpenStack API}
  spec.homepage      = "https://github.com/relaxdiego/redstack"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 4.7.0"
  spec.add_development_dependency 'rb-fsevent', '~> 0.9'
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rake"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency 'ruby_gntp'
  spec.add_development_dependency "debugger"
  spec.add_development_dependency "pry"
end
