namespace :jar do
  target_dir = "classes"

  desc "Compile and create celerity-complete-#{Celerity::VERSION}.jar (includes HtmlUnit)"
  task :fat do
    file_name = "pkg/celerity-complete-#{Celerity::VERSION}.jar"

    ruby_files = Dir['lib/**/*.rb']
    jar_files  = Dir['lib/**/*.jar']
    resources  = Dir['lib/celerity/resources/*']

    rm_rf   target_dir if File.exist? target_dir
    mkdir   target_dir
    mkdir_p resource_dir = "#{target_dir}/celerity/resources"

    sh "jrubyc", "-d", "lib", "-t", target_dir, *ruby_files
    resources.each { |extra| cp extra, resource_dir }

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

  desc "Compile and create celerity-#{Celerity::VERSION}.jar"
  task :tiny do
    file_name = "pkg/celerity-#{Celerity::VERSION}.jar"

    ruby_files = Dir['lib/**/*.rb']
    resources  = Dir['lib/celerity/resources/*']

    rm_rf   target_dir if File.exist? target_dir
    mkdir   target_dir
    mkdir_p resource_dir = "#{target_dir}/celerity/resources"

    sh "jrubyc", "-d", "lib", "-t", target_dir, *ruby_files
    resources.each { |extra| cp extra, resource_dir }

    mkdir_p "pkg"
    sh "jar", "cvf", file_name, '-C', target_dir, '.'
  end
end

desc 'Alias for jar:tiny'
task :jar => %w[jar:tiny]