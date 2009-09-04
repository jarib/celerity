require 'rubygems'
gem 'hoe', '>= 2.3.0'
require 'hoe'
%w[fileutils rubigen].each { |f| require f }

require "lib/celerity/version"

Hoe.plugin :newgem # newgem 1.5.2+
Hoe.plugin :website

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
Hoe.spec 'celerity' do
  developer   "Jari Bakken", "jari.bakken@finn.no"
  version     = Celerity::VERSION
  clean_globs = %w[classes/**/* pkg/**/* doc/**/*]

  author         << "Jari Bakken" << "T. Alexander Lystad" << "Knut Johannes Dahle"
  email          << "jari.bakken@finn.no"
  extra_dev_deps << ['sinatra', '>= 0.9.4']

  # hack to avoid the extra file
  @website_config = {'host' => 'jarib@rubyforge.org', 'remote_dir' => "/var/www/gforge-projects/celerity"}
end

Dir['tasks/**/*.rake'].each do |rake|
  begin
    load rake
  rescue LoadError
  end
end
# load 'tasks/jar.rake'
# load 'tasks/rdoc.rake'
