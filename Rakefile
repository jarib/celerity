require 'rubygems'
require 'rake'
require File.expand_path("lib/celerity/version", File.dirname(__FILE__))

Dir['tasks/**/*.rake'].each do |rake|
  begin
    load rake
  rescue LoadError => e
    puts e.message
  end
end
