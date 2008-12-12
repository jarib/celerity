desc 'Generate YARD docs in website/yard/'
task :yardoc2website do
  mkdir_p "website/yard", :verbose => true
  sh "yardoc --verbose -o website/yard"
end