


task :snapshot do
  files = %w[
    http://build.canoo.com/htmlunit/artifacts/htmlunit-2.4-SNAPSHOT.jar
    http://htmlunit.sourceforge.net/m2-repo-snapshots/net/sourceforge/htmlunit/htmlunit-core-js/2.4-SNAPSHOT/htmlunit-core-js-2.4-SNAPSHOT.jar
  ]
  
  files.each do |url|
    puts ":"*(6+url.size)
    puts ":: #{url} ::"
    puts ":"*(6+url.size)
    
    system "curl -O #{url}"
  end  
end