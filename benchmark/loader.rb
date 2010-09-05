require 'benchmark'


def create_browser
  if RUBY_PLATFORM =~ /java/
    require File.expand_path("../lib/celerity", File.dirname(__FILE__))
    browser = Celerity::Browser.new(:log_level => :off)
  else
    require 'watir-webdriver'
    browser = Watir::Browser.new :firefox
  end

  browser
end

HTML_DIR = "file://" + File.expand_path("../spec/watirspec/html", File.dirname(__FILE__))
