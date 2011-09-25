require 'rubygems'
require 'rake'

include Rake::DSL

require 'bundler'
Bundler::GemHelper.install_tasks

Dir['tasks/**/*.rake'].each do |rake|
  begin
    load rake
  rescue LoadError => e
    puts e.message
  end
end
