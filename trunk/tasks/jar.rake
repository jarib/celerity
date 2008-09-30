require 'celerity/version'


namespace :jar do
  desc "Compile and create celerity-complete-#{Celerity::VERSION::STRING}.jar (includes HtmlUnit)"
  task :complete do
    file_name = "celerity-complete-#{Celerity::VERSION::STRING}.jar"
  
    ruby_files = Dir['lib/**/*.rb']
    jar_files  = Dir['lib/**/*.jar']

    target_dir = "target"
    rm_rf target_dir if File.exist? target_dir
    mkdir target_dir
  
    sh "jrubyc", "-d", "lib", "-t", target_dir, *ruby_files
  
    classes = Dir['target/**/*.class']
    sh "jar", "cvf", file_name, *(jar_files + classes)
  end
  
  desc "Compile and create celerity-#{Celerity::VERSION::STRING}.jar (no HtmlUnit)"
  task :tiny do
    file_name = "celerity-#{Celerity::VERSION::STRING}.jar"
  
    ruby_files = Dir['lib/**/*.rb']

    target_dir = "target"
    rm_rf target_dir if File.exist? target_dir
    mkdir target_dir
  
    sh "jrubyc", "-d", "lib", "-t", target_dir, *ruby_files
  
    classes = Dir['target/**/*.class']
    sh "jar", "cvf", file_name, target_dir
  end
end

desc 'Alias for jar:complete'
task :jar => %w[jar:complete]