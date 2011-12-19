namespace :fix do

  desc 'Make all ruby files use LF line endings'
  task :crlf do
    files = FileList['**/*.rb']
    files.each do |f|
      next if File.directory?(f)
      s = IO.read(f)
      s.gsub!(/\r?\n/, "\n")
      File.open(f, "w") { |io| io.write(s) }
    end
  end

  desc 'Remove trailing whitespace from all ruby files'
  task :trailing_whitespace do
    files = FileList['**/*.rb']
    files.each do |f|
      next if File.directory?(f)
      s = IO.read(f)
      s.gsub!(/\s*?($)/, '\1')
      File.open(f, "w") { |io| io.write(s) }
    end
  end

end