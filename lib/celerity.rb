$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

raise "Celerity only works on JRuby at the moment." unless RUBY_PLATFORM =~ /java/

require "java"
require "logger"
require "uri"
require "pp"
require "timeout"
require "time"
require "socket"
require "fileutils"
require "thread"

module Celerity
  Log = Logger.new($DEBUG ? $stderr : nil)
  Log.level = Logger::DEBUG

  DIR = File.expand_path(File.dirname(__FILE__) + "/celerity")
end

require "celerity/version"
require "celerity/htmlunit"
require "celerity/exception"
require "celerity/clickable_element"
require "celerity/disabled_element"
require "celerity/element_collection"
require "celerity/collections"
require "celerity/element_locator"
require "celerity/identifier"
require "celerity/short_inspect"
require "celerity/container"
require "celerity/xpath_support"
require "celerity/element"
require "celerity/input_element"
require "celerity/elements/non_control_elements"
require "celerity/elements/button"
require "celerity/elements/file_field"
require "celerity/elements/form"
require "celerity/elements/frame"
require "celerity/elements/image"
require "celerity/elements/label"
require "celerity/elements/link"
require "celerity/elements/meta"
require "celerity/elements/option"
require "celerity/elements/radio_check"
require "celerity/elements/select_list"
require "celerity/elements/table"
require "celerity/elements/table_elements"
require "celerity/elements/table_cell"
require "celerity/elements/table_row"
require "celerity/elements/text_field"
require "celerity/util"
require "celerity/default_viewer"
require "celerity/listener"
require "celerity/ignoring_web_connection"
require "celerity/javascript_debugger"
require "celerity/viewer_connection"
require "celerity/browser"

# undefine deprecated methods to use them for Element attributes
Object.send :undef_method, :id   if Object.method_defined? "id"
Object.send :undef_method, :type if Object.method_defined? "type"
