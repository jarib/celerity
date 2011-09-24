desc 'Download and unpack the latest HtmlUnit assembly'
task :snapshot, :file do |t, args|
  if args.file
    sh "cp #{args.file} ./"
    basename = File.basename(args.file)
  else
    url = "http://build.canoo.com/htmlunit/artifacts//htmlunit-2.10-SNAPSHOT-with-dependencies.zip"
    sh "curl -O #{url}"
    basename = File.basename(url)
  end

  shortname = basename[/(.+?)\.zip/, 1].sub("-with-dependencies", '')
  sh "rm -rf lib/celerity/htmlunit/*.jar"
  sh "unzip -tq #{basename}"
  sh %Q{unzip -C #{basename} "#{shortname}/lib/*.jar" -d lib/celerity/htmlunit }

  puts "Fixing paths..."
  sh "cp -R lib/celerity/htmlunit/#{shortname}/lib/*.jar lib/celerity/htmlunit/"

  puts "Cleaning..."
  rm_r "lib/celerity/htmlunit/#{shortname}/"
  rm basename

  puts "...done!"
end
