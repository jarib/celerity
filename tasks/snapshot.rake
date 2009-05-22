desc 'Download and unpack the latest HtmlUnit assembly'
task :snapshot do
  files = %w[ http://build.canoo.com/htmlunit/artifacts/htmlunit-2.6-SNAPSHOT-with-dependencies.zip ]
  
  files.each do |url|
    basename = File.basename(url)
    shortname = basename[/(.+?)\.zip/, 1].sub("-with-dependencies", '')
    puts ":"*(6+url.size)
    puts ":: #{url} ::"
    puts ":"*(6+url.size)
    
    sh "curl -O #{url}"
    sh "rm -rf lib/celerity/htmlunit/*.jar"
    sh "unzip -tq #{basename}"
    sh %Q{unzip -C #{basename} "#{shortname}/lib/*.jar" -d lib/celerity/htmlunit }
    
    puts "Fixing paths..."
    sh "cp -R lib/celerity/htmlunit/#{shortname}/lib/*.jar lib/celerity/htmlunit/"
    sh "rm -r lib/celerity/htmlunit/#{shortname}/"
    
    puts "Cleaning..."
    rm basename
    
    puts "...done!"
  end  
end