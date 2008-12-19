$:.unshift("#{File.dirname(__FILE__)}/lib")

if File.exist?('config') # are we in a git clone
  require 'config/requirements'
  require 'config/hoe' # setup Hoe + all gem configuration
  Dir['tasks/**/*.rake'].each { |rake| load rake }
else # in gem dir
  load 'tasks/jar.rake'
  load 'tasks/rdoc.rake'
end


