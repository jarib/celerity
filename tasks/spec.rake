require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.ruby_opts = "-I lib:spec"
  spec.pattern   = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.ruby_opts = "-I lib:spec"
  spec.pattern   = 'spec/**/*_spec.rb'
  spec.rcov      = true
  spec.rcov_opts = %w[--exclude spec,fcntl,path_helper,yaml,rack,jruby --include lib/celerity --no-rcovrt]
end

if File.exist?(path = "spec/watirspec/watirspec.rake")
  load path
end

namespace :watirspec do
  desc 'Initialize and fetch the watirspec submodule'
  task :init do
    sh "git submodule init"
    sh "git submodule update"
  end
end

task :default => :spec
