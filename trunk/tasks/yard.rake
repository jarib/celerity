desc 'Generate YARD docs in website/yard/'
task :yardoc2website do
  sh "yardoc --verbose -d website/yard"
end