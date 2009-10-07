

namespace :website
  desc 'Upload website files to rubyforge'
  task :upload do
    host       = "#{rubyforge_username}@rubyforge.org"
    remote_dir = "/var/www/gforge-projects/#{PATH}/"
    local_dir  = 'website'
  
    sh %{rsync -rlgoDCv #{local_dir}/ #{host}:#{remote_dir}}
  end
end