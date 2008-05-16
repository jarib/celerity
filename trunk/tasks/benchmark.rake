desc "Run benchmark scripts"
task :benchmark do
  Dir[File.dirname(__FILE__) + "/../benchmark/*.rb"].each { |f| load f }
end