$:.unshift File.expand_path("../lib", File.dirname(__FILE__))
require 'celerity'

include Celerity
include Celerity::Exception
java.lang.System.setProperty("java.awt.headless", "true")


if defined? WatirSpec
  WatirSpec.implementation do |imp|
    imp.name          = :celerity
    imp.browser_class = Celerity::Browser
    imp.browser_args  = [{ :log_level => $DEBUG ? :all : :off }]
  end
end
