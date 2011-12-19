namespace :check do

  desc 'Check syntax of all .rb files'
  task :syntax do
    failed = []

    Dir['**/*.rb'].each do |f|
      begin
        eval("lambda do\n return true\n #{File.read f} \nend").call
        print "."
      rescue SyntaxError => e
        print "!"
        failed <<  [f, e.message]
      end
    end

    if failed.empty?
      puts "ok."
    else
      puts "\n\t#{failed.join("\n\t")}"
    end
  end

end