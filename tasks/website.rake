namespace :website do
  desc 'Upload website files to rubyforge'
  task :upload do
    host       = "jarib@rubyforge.org"
    remote_dir = "/var/www/gforge-projects/celerity"
    local_dir  = 'website'

    sh %{rsync -rlgoDCv #{local_dir}/ #{host}:#{remote_dir}}
  end
end