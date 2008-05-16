desc 'Generate RDoc'
task :rdoc do
  puts `rdoc --inline-source --line-numbers --title 'Celerity Documentation' --opname index.html --main README.txt lib History.txt License.txt README.txt`
end