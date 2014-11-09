# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'onlinelabs/version'

Gem::Specification.new do |gem|
  gem.name          = "onlinelabs"
  gem.version       = OnlineLabs::VERSION
  gem.authors       = ["bchatelard"]
  gem.email         = ["chatel.bast@gmail.com"]
  gem.description   = %q{Ruby bindings for the Online Labs API.}
  gem.summary       = %q{Ruby bindings for the Online Labs API.}
  gem.homepage      = "http://github.com/bchatelard/onlinelabs-ruby"

  gem.add_dependency "faraday", "~> 0.9"
  gem.add_dependency "faraday_middleware", "~> 0.9"
  gem.add_dependency "recursive-open-struct", "~> 0.5"

  gem.add_development_dependency "rake", "~> 10.1"
  gem.add_development_dependency "rspec", "~> 3.1"
  gem.add_development_dependency "its", "~> 0.2"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end