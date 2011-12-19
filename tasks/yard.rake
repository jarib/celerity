begin
  require 'yard'
  YARD::Rake::YardocTask.new

  desc 'Generate docs to website/yard'
  namespace :yardoc do
    YARD::Rake::YardocTask.new(:website) do |t|
      t.options += ["-o", "website/yard"]
    end
  end

rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
