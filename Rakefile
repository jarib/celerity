require 'rubygems'
require 'rake'
require "lib/celerity/version"

Dir['tasks/**/*.rake'].each do |rake|
  begin
    load rake
  rescue LoadError => e
    puts e.message
  end
end
