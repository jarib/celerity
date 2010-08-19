$:.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib")
require 'celerity'

include Celerity
include Celerity::Exception
java.lang.System.setProperty("java.awt.headless", "true")

WatirSpec.implementation do |imp|
  imp.name          = :celerity
  imp.browser_class = Celerity::Browser
  imp.browser_args  = [{ :log_level => $DEBUG ? :all : :off }]
end