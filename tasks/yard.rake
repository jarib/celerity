begin
  
  require "yard"
  
  YARD::Rake::YardocTask.new do |t|
    t.files    = ["lib/**/*.rb"]
    t.options += ["-o", "website/yard"]
  end
  
rescue LoadError
end
# 
# 
# desc 'Generate YARD docs in website/yard/'
# task :yardoc2website do
#   mkdir_p "website/yard", :verbose => true
# end