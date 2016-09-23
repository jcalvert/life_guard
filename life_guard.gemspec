# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'life_guard/version'

Gem::Specification.new do |spec|
  spec.name          = "life_guard"
  spec.version       = LifeGuard::VERSION
  spec.authors       = ["Jon Calvert"]
  spec.email         = ["jecalvert@gmail.com"]

  spec.summary       = %q{Manage the (active_record connection) pool}
  spec.description   = %q{Manage the (active_record connection) pool via Rack middleware}
  spec.homepage      = "http://github.com/jcalvert/life_guard"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("activerecord", ">= 4.0")

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sqlite3", ">= 1.3.4"
  spec.add_development_dependency "rack", ">= 1.6.4"
  spec.add_development_dependency "mocha", "1.1.0"
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rails', ">= 4.2.0"

end
