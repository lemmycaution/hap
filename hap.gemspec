# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hap/version'

Gem::Specification.new do |spec|
  spec.name          = "hap"
  spec.version       = Hap::VERSION
  spec.authors       = ["lemmycaution"]
  spec.email         = ["fluxproject@gmail.com"]
  spec.description   = %q{An Interface to help creating multi-server high scalable APIs on heroku}
  spec.summary       = %q{Hap is a CLI and a bit much more to manage `App per Resource` APIs based on Goliath and HaProxy}
  spec.homepage      = "http://github.com/lemmycaution/hap"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  
  spec.add_development_dependency "minitest"
end
