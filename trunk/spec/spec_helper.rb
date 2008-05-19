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
    # cleaner way to do this?
    require File.dirname(__FILE__) + "/../support/spec_server"
    s = Celerity::SpecServer.new
    s.run
    TEST_HOST = s.host
  end
else
  puts "Remember to run \"rake specserver\" before running these tests!"
  TEST_HOST = "http://localhost:2000"
end

# ===========================
# = RubyCocoa CelerityViewer =
# ===========================
begin
  if `uname`.chomp == "Darwin" && `ps ax`[/CelerityViewer/]
    WEB_VIEWER = DRbObject.new_with_uri("druby://127.0.0.1:1337")
  end
rescue IOError, Errno::ENOENT
end

# ================
# = Spec Checker =
# ================

# define a checker that is run on every page
def add_spec_checker(browser)
  if defined? WEB_VIEWER
    browser.add_checker { WEB_VIEWER.render_html(browser.html, browser.base_url) }
  end
end



