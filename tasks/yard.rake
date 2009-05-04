begin
  require "yard"
  
  YARD::Rake::YardocTask.new do |t|
    t.files    = ["lib/**/*.rb"]
    t.options += ["-o", "website/yard"]
  end
rescue LoadError
end
