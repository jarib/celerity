require "fileutils"

begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

# require "profile"

$:.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib")

if RUBY_PLATFORM =~ /java/
  require 'celerity'
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
  # TEST_HOST = "file://#{File.dirname(__FILE__)}/html"
else
  puts "Remember to run \"rake specserver\" before running these tests!"
  TEST_HOST = "http://localhost:2000"
end

HTML_DIR = "file://#{File.expand_path(File.dirname(__FILE__))}/html"