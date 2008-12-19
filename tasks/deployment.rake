#desc 'Release the website and new gem version'
#task :deploy => [:check_version, :website, :release] do
#  puts "Remember to create SVN tag:"
#  puts "svn copy svn+ssh://#{rubyforge_username}@rubyforge.org/var/svn/#{PATH}/trunk " +
#    "svn+ssh://#{rubyforge_username}@rubyforge.org/var/svn/#{PATH}/tags/REL-#{VERS} "
#  puts "Suggested comment:"
#  puts "Tagging release #{CHANGES}"
#end

desc 'Builds and installs gem locally'
task :local_deploy => [:install_gem]

#task :check_version do
#  unless ENV['VERSION']
#    puts 'Must pass a VERSION=x.y.z release version'
#    exit
#  end
#  unless ENV['VERSION'] == VERS
#    puts "Please update your version.rb to match the release version, currently #{VERS}"
#    exit
#  end
#end

#desc 'Install the package as a gem, without generating documentation(ri/rdoc)'
#task :install_gem_no_doc => [:clean, :package] do
#  sh "#{'sudo ' unless Hoe::WINDOZE }gem install pkg/*.gem --no-rdoc --no-ri"
#end

namespace :manifest do
  desc 'Recreate Manifest.txt to include ALL files'
  task :refresh do
    `rake check_manifest | patch -p0 > Manifest.txt`
  end
  desc 'Create new Manifest.txt in diff format'
  task :new do
    manifest = File.new('Manifest.txt', 'w+')
    Dir.glob(File.join("**", "*")).each do |f|
      manifest.puts f
    end
    manifest.flush
    puts "####\n# Remember to edit Manifest.txt and remove unwanted file entries!\n####"
  end
end
