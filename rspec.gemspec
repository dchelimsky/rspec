# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "spec/version"

Gem::Specification.new do |s|
  s.name        = "rspec"
  s.version     = Spec::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["The RSpec Development Team"]
  s.email       = ["rspec-devel@rubyforge.org"]
  s.homepage    = ""
  s.summary     = Spec::VERSION::SUMMARY
  s.description = "Behaviour Driven Development for Ruby."

  s.rubyforge_project = "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency("cucumber",">=0.3")
  s.add_development_dependency("fakefs",">=0.2.1")
  s.add_development_dependency("syntax",">=1.0")
  s.add_development_dependency("diff-lcs",">=1.1.2")
end
