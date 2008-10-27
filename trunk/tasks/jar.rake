require 'celerity/version'

namespace :jar do
  target_dir = "classes"

  desc "Compile and create celerity-complete-#{Celerity::VERSION::STRING}.jar (includes HtmlUnit)"
  task :fat do
    file_name = "pkg/celerity-complete-#{Celerity::VERSION::STRING}.jar"

    ruby_files = Dir['lib/**/*.rb']
    jar_files  = Dir['lib/**/*.jar']

    rm_rf target_dir if File.exist? target_dir
    mkdir target_dir

    sh "jrubyc", "-d", "lib", "-t", target_dir, *ruby_files

    jar_files.each do |f|
      cp f, target_dir
    end

    top_dir = Dir.pwd
    chdir target_dir, :verbose => true
    Dir['*.jar'].each do |file|
      sh "jar", "xf", file
      rm_f file
    end
    chdir top_dir, :verbose => true

    mkdir_p "pkg"
    sh "jar", "cvf", file_name, '-C', target_dir, '.'
  end

  desc "Compile and create celerity-#{Celerity::VERSION::STRING}.jar"
  task :tiny do
    file_name = "pkg/celerity-#{Celerity::VERSION::STRING}.jar"

    ruby_files = Dir['lib/**/*.rb']

    rm_rf target_dir if File.exist? target_dir
    mkdir target_dir

    sh "jrubyc", "-d", "lib", "-t", target_dir, *ruby_files

    mkdir_p "pkg"
    sh "jar", "cvf", file_name, '-C', target_dir, '.'
  end
end

desc 'Alias for jar:tiny'
task :jar => %w[jar:tiny]