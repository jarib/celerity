$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Celerity
  Jars = Dir[File.dirname(__FILE__) + '/celerity/htmlunit/*.jar']
end

if RUBY_PLATFORM =~ /java/
  require 'java'
  Celerity::Jars.each { |jar| require(jar) }

  module HtmlUnit
    include_package 'com.gargoylesoftware.htmlunit'
  end
  JavaString = java.lang.String
else
  raise "Celerity only works on JRuby at the moment."
end
  # require "rjb"
  # Rjb::load(Celerity::Jars.join(";"))
  # module HtmlUnit
  #   WebClient      = Rjb::import('com.gargoylesoftware.htmlunit.WebClient')
  #   BrowserVersion = Rjb::import('com.gargoylesoftware.htmlunit.BrowserVersion')
  # end

require "celerity/version"
require "celerity/exception"
require "celerity/clickable_element"
require "celerity/disabled_element"
require "celerity/element_collections"
require "celerity/collections"
require "celerity/element_locator"
require "celerity/identifier"
require "celerity/container"
require "celerity/element"
require "celerity/input_element"
require "celerity/non_control_elements"
Dir[File.dirname(__FILE__) + "/celerity/elements/*.rb"].each { |f| require(f) }
require "celerity/browser"

require "celerity/watir_compatibility"

require "logger"
require "uri"
require "pp"
require "time"

Log = Logger.new($DEBUG ? $stderr : nil)
Log.level = Logger::DEBUG
# undefine deprecated methods to use them for Element attributes
Object.send :undef_method, :id
Object.send :undef_method, :type

