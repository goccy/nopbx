# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nopbx/version'

Gem::Specification.new do |spec|
  spec.name          = "nopbx"
  spec.version       = Nopbx::VERSION
  spec.authors       = ["goccy"]
  spec.email         = ["goccy54@gmail.com"]
  spec.summary       = %q{Provides method of removing project.pbxproj from your project.}
  spec.description   = %q{Provides method of removing project.pbxproj from your project.}
  spec.homepage      = "https://github.com/goccy/nopbx/wiki"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "thor"
  spec.add_development_dependency "term-ansicolor"
  spec.add_development_dependency "listen"

end
