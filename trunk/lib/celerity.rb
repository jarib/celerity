$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

HTMLUNIT_JARS = Dir[File.dirname(__FILE__) + '/celerity/htmlunit/*.jar']

if RUBY_PLATFORM =~ /java/
  require 'java'
  HTMLUNIT_JARS.each { |jar| require(jar) }

  module HtmlUnit
    include_package 'com.gargoylesoftware.htmlunit'
  end
  ArrayList = java.util.ArrayList
else
  require "rjb"
  require "watir"
  Rjb::load(HTMLUNIT_JARS.join(";"))
  module HtmlUnit
    WebClient = Rjb::import('com.gargoylesoftware.htmlunit.WebClient')
    BrowserVersion = Rjb::import('com.gargoylesoftware.htmlunit.BrowserVersion')
  end
end

module Celerity; end
require "celerity/version"
require "celerity/exception"
require "celerity/clickable_element"
require "celerity/disabled_element"
require "celerity/element_collections"
require "celerity/collections"
require "celerity/container"
require "celerity/element"
require "celerity/input_element"
require "celerity/non_control_elements"
Dir[File.dirname(__FILE__) + "/celerity/elements/*.rb"].each { |f| require(f) }
require "celerity/ie"

require "logger"
require "uri"
require "pp"
require "time"

Log = Logger.new($DEBUG ? $stderr : nil)
Log.level = Logger::DEBUG
# undefine deprecated methods to use them for Element attributes
Object.send :undef_method, :id
Object.send :undef_method, :type

