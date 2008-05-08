require "rubygems"
require "fileutils"
require "erb"
require "pp"

begin
  require "mongrel"
rescue LoadError
end

task :simple_ci do
  INTERVAL = (60*5)
  CI_ROOT = File.dirname(__FILE__) + "/../simple_ci"
  ROOT    = File.expand_path(CI_ROOT + "/..")
  Dir.mkdir(CI_ROOT) unless File.exist?(CI_ROOT)

   class SpecFile < Struct.new(:file, :describes)
     attr_accessor :passed
  end

  def get_specs
    Dir[File.dirname(__FILE__) + '/../spec/**/*_spec.rb'].map do |file|
      SpecFile.new(file, File.read(file)[/describe\(?\s*["'](.+?)["']/, 1] || File.basename(file) )
    end
  end

  class SimpleCI < Mongrel::HttpHandler
    def self.template=(rhtml); @@template = rhtml; end

    def initialize(results)
      @results = results
      super()
    end

    def process(request, response)
      response.start(200) do |header, io|
        if @results
          io.write ERB.new(@@template).result
        end
      end
    end

  end

  @results = {}
  SimpleCI.template = <<-HTML
  <html>
    <head>
      <meta http-equiv="Content-type" content="text/html; charset=utf-8">
      <title>Celerity Simple CI</title>
      <style type="text/css" media="screen">
        body {font: 10px/16px "Lucida Grande", Geneva, Arial, Verdana, sans-serif; background-color: #fff;color: #333;}
        a{color:#2971a7;}
        a:link,a:visited,a:active{text-decoration:none}
        a:hover{text-decoration:underline}
        table{border-collapse:collapse;border-spacing:0;margin-left:24px;}
      </style>
    </head>

    <h1> Celerity </h1>
    <h3><a href="result/">Test Results</a></h3>
    <h3><a href="coverage/">Code Coverage</a></h3>
  </html>
  HTML

  begin
    @server = Mongrel::HttpServer.new('0.0.0.0', '8080')
  rescue NameError
    abort("Run `(jruby -S) gem install mongrel` to use this task.")
  end
  @server.register("/result", Mongrel::DirHandler.new(CI_ROOT))
  @server.register("/coverage", Mongrel::DirHandler.new(CI_ROOT + "/coverage/coverage"))
  @server.register("/", SimpleCI.new(@results))
  Thread.new { @server.run.join }
  puts "simple_ci started on #{@server.host}:#{@server.port}"
  loop do
    puts %x{svn up}
    puts "*** running specs at #{Time.now}"
    specs = get_specs

    pp specs if $DEBUG
    puts "*** running rcov at #{Time.now}"
    puts %x{jruby -S rake --silent spec > #{CI_ROOT}/index2.html}
    FileUtils.mv(CI_ROOT + "/index2.html", CI_ROOT + "/index.html", :verbose => true)
    Dir[CI_ROOT + "/coverage/*"].each { |f| FileUtils.rm_r(f, :verbose => true) }
    FileUtils.mv(CI_ROOT + "/../coverage", CI_ROOT + "/coverage", :verbose => true)
    puts "\n*** sleeping #{Time.now}"
    sleep(INTERVAL)
  end

end



