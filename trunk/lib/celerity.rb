$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

raise "Celerity only works on JRuby at the moment." unless RUBY_PLATFORM =~ /java/
# Celerity - JRuby wrapper for HtmlUnit
module Celerity
  Jars = Dir[File.dirname(__FILE__) + '/celerity/htmlunit/*.jar']
end

require 'java'
JavaString = java.lang.String

Celerity::Jars.each { |jar| require(jar) }

module HtmlUnit
  include_package 'com.gargoylesoftware.htmlunit'

  module Html
    include_package 'com.gargoylesoftware.htmlunit.html'
  end
end

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
require "celerity/elements/button.rb"
require "celerity/elements/file_field.rb"
require "celerity/elements/form.rb"
require "celerity/elements/frame.rb"
require "celerity/elements/image.rb"
require "celerity/elements/label.rb"
require "celerity/elements/link.rb"
require "celerity/elements/option.rb"
require "celerity/elements/radio_check.rb"
require "celerity/elements/select_list.rb"
require "celerity/elements/table.rb"
require "celerity/elements/table_body.rb"
require "celerity/elements/table_cell.rb"
require "celerity/elements/table_footer.rb"
require "celerity/elements/table_header.rb"
require "celerity/elements/table_row.rb"
require "celerity/elements/text_field.rb"
require "celerity/element_map"
require "celerity/browser"

require "celerity/watir_compatibility"

require "logger"
require "uri"
require "pp"
require "timeout"
require "time"

module Celerity
  Log = Logger.new($DEBUG ? $stderr : nil)
  Log.level = Logger::DEBUG
end

# undefine deprecated methods to use them for Element attributes
Object.send :undef_method, :id   if Object.method_defined? "id"
Object.send :undef_method, :type if Object.method_defined? "type"
