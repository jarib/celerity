require 'benchmark'
require File.dirname(__FILE__) + "/../spec/spec_helper"


def create_browser
  if RUBY_PLATFORM =~ /java/
    browser = Celerity::Browser.new(:log_level => :off)
  else
    require 'watir'
    browser = Watir::IE.new
  end

  browser
end
