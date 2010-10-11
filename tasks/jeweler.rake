# encoding: utf-8

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    # see http://www.rubygems.org/read/chapter/20 for additional settings
    gem.name              = "celerity"
    gem.summary           = "Celerity is a JRuby library for easy and fast functional test automation for web applications."
    gem.description       = "Celerity is a JRuby wrapper around HtmlUnit – a headless Java browser with JavaScript support. It provides a simple API for programmatic navigation through web applications. Celerity provides a superset of Watir's API."
    gem.email             = "jari.bakken@gmail.com"
    gem.homepage          = "http://github.com/jarib/celerity"
    gem.authors           = ["Jari Bakken", "T. Alexander Lystad", "Knut Johannes Dahle"]
    gem.rubyforge_project = "celerity"
    gem.test_files        = [] # the gem is big enough as it is

    gem.files.reject! { |f| f =~ /^(website|doc|benchmark|log|spec|\.)/}

    gem.add_development_dependency 'rspec', "~> 2.0.0"
    gem.add_development_dependency 'yard'
    gem.add_development_dependency 'sinatra', '>= 1.0'
    gem.add_development_dependency 'mongrel'
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
  task :spec    => :check_dependencies
end
