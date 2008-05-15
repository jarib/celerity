require "fileutils"

begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

# require "profile"

$:.unshift(File.dirname(__FILE__) + '/../lib')

if RUBY_PLATFORM =~ /java/
  require 'celerity'
  include Celerity
  include Celerity::Exception  
else
  require 'watir'
  include Watir
  include Watir::Exception  
end

# ============
# = Debugger =
# ============

if ENV['DEBUGGER']
  require "ruby-debug"
  Debugger.start
  Debugger.settings[:autoeval] = true
  Debugger.settings[:autolist] = 1
end

# ===========
# = WEBrick =
# ===========

if RUBY_PLATFORM =~ /java/ || ENV['WATIR_SPEC']
  unless defined? WEBRICK_SERVER
    require 'webrick'
    doc_root = File.join(File.dirname(__FILE__), "html")
    log_file = File.join(File.dirname(__FILE__), "..", "log", "webrick_log.txt")
    unless File.exist?(log_file)
      FileUtils.mkdir_p(File.dirname(log_file))
      FileUtils.touch(log_file)
    end
    
    server_port = 2000
    tries = 0
    begin
      TEST_HOST = "http://localhost:#{server_port}"
      server = WEBrick::HTTPServer.new(:Port => server_port,
                                       :DocumentRoot => doc_root,
                                       :Logger => WEBrick::Log.new(log_file, WEBrick::BasicLog::WARN),
                                       :AccessLog => [])
    rescue Errno::EADDRINUSE => e
      server_port += 5
      if tries < 3
        tries += 1
        retry 
      else
        raise e
      end
    end
    
    class PostServlet < WEBrick::HTTPServlet::AbstractServlet
      def do_POST(req, resp)
        resp['content-type'] = 'text/html'
        resp.body << "<html><body>"
        resp.body << "You posted the following content:\n"
        resp.body << req.body
        resp.body << "</body></html>"
      end
    end
    
    server.mount("/", WEBrick::HTTPServlet::FileHandler, doc_root, {:FancyIndexing=>true})
    server.mount("/post_to_me", PostServlet)
    WEBRICK_SERVER = Thread.new { server.start }
  end
else
  puts "Remember to run \"rake testserver\" before running these tests!"
  TEST_HOST = "http://localhost:2000"
end

# ===========================
# = RubyCocoa CelerityViewer =
# ===========================
begin
  if `uname`.chomp == "Darwin" && `ps ax`[/CelerityViewer/]
    WEB_VIEWER = DRbObject.new_with_uri("druby://127.0.0.1:1337")
  end
rescue IOError
rescue Errno::ENOENT
end

# ================
# = Spec Checker =
# ================

# define a checker that is run on every page
def add_spec_checker(browser)
  if defined? WEB_VIEWER
    ie.add_checker { WEB_VIEWER.render_html(browser.html, ie.base_url) }
  end
end



