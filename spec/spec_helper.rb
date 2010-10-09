$:.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib")
require 'celerity'

include Celerity
include Celerity::Exception
java.lang.System.setProperty("java.awt.headless", "true")
