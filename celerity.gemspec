# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'celerity/version'

Gem::Specification.new do |s|
  s.name              = %q{celerity}
  s.version           = Celerity::VERSION
  s.authors           = ["Jari Bakken", "T. Alexander Lystad", "Knut Johannes Dahle"]
  s.description       = "Celerity is a JRuby wrapper around HtmlUnit – a headless Java browser with JavaScript support. It provides a simple API for programmatic navigation through web applications. Celerity provides a superset of Watir's API."
  s.summary           = %q{Celerity is a JRuby library for easy and fast functional test automation for web applications.}
  s.email             = %q{jari.bakken@gmail.com}
  s.homepage          = %q{http://github.com/jarib/celerity}
  s.require_paths     = ["lib"]
  s.rubyforge_project = %q{celerity}

  s.add_development_dependency "rake", "~> 0.9.2"
  s.add_development_dependency "rspec", "~> 2.0.0"
  s.add_development_dependency "yard", ">= 0"
  s.add_development_dependency "sinatra", "~> 1.0"
  s.add_development_dependency "mongrel", ">= 0"

  s.files       = `git ls-files`.split("\n")
  s.test_files  = []
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
end

