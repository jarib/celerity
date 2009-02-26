require "fileutils"

begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

if RUBY_PLATFORM =~ /java/
  if ENV['CELERITY_JAR'] == '1'
    require Dir["pkg/celerity-complete-*.jar"].first
    require "celerity"
  else
    $:.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib")
    require 'celerity'
  end
  
  include Celerity
  include Celerity::Exception
else
  puts "Not using JRuby - trying to run specs on Watir…"
  require 'watir'
  include Watir
  include Watir::Exception
end

# ============
# = Debugger =
# ============

if ENV['DEBUGGER'] || $DEBUG
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
    require File.dirname(__FILE__) + "/../support/spec_server"
    s = Celerity::SpecServer.new
    begin
      s.run
    rescue Errno::EADDRINUSE
    end
    TEST_HOST = s.host
  end
else
  puts "Remember to run \"rake specserver\" before running these tests!"
  TEST_HOST = "http://localhost:2000"
end

HTML_DIR = "file://#{File.expand_path(File.dirname(__FILE__))}/html"
BROWSER_OPTIONS = {
  :log_level => $DEBUG ? :all : :off,
  # :browser   => :firefox
}

Thread.abort_on_exception = true