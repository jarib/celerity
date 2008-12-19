namespace :specserver do
  task :http do
    require File.dirname(__FILE__) + "/../support/spec_server.rb"
    s = Celerity::SpecServer.new
    s.run
    puts "server started on #{s.host}\n    log at: #{s.log_file}"
    s.thread.join 
  end

  desc "Run HTTPS webserver for specs"
  task :https do
    require File.dirname(__FILE__) + "/../support/spec_server.rb"
    s = Celerity::SpecServer.new(:ssl => true)
    s.run
    puts "server started on #{s.host}\n    log at: #{s.log_file}"
    s.thread.join
  end
end

desc "Run HTTP webserver for specs"
task :specserver => [:'specserver:http']