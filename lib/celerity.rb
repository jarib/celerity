$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

raise "Celerity only works on JRuby at the moment." unless RUBY_PLATFORM =~ /java/

require "java"
require "logger"
require "uri"
require "pp"
require "timeout"
require "time"
require "drb"
require "fileutils"
require "thread"

module Celerity
  Log = Logger.new($DEBUG ? $stderr : nil)
  Log.level = Logger::DEBUG

  @index_offset = 1
  class << self

    #
    # This index_offset attribute controls the indexing used when locating
    # elements by :index or fetching from Celerity::ElementCollections.
    #
    # By default it is set to 1 for Watir compatibility, but users who use
    # Celerity exlusively may want it set to 0 to make Celerity more consistent with Ruby.
    #
    def index_offset=(n) @index_offset = n end
    def index_offset() @index_offset end
  end

  DIR = File.expand_path(File.dirname(__FILE__) + "/celerity")
end

require "celerity/htmlunit"
require "celerity/version"
require "celerity/exception"
require "celerity/clickable_element"
require "celerity/disabled_element"
require "celerity/element_collection"
require "celerity/collections"
require "celerity/element_locator"
require "celerity/identifier"
require "celerity/short_inspect"
require "celerity/container"
require "celerity/element"
require "celerity/input_element"
require "celerity/elements/non_control_elements"
require "celerity/elements/button.rb"
require "celerity/elements/file_field.rb"
require "celerity/elements/form.rb"
require "celerity/elements/frame.rb"
require "celerity/elements/image.rb"
require "celerity/elements/label.rb"
require "celerity/elements/link.rb"
require "celerity/elements/meta.rb"
require "celerity/elements/option.rb"
require "celerity/elements/radio_check.rb"
require "celerity/elements/select_list.rb"
require "celerity/elements/table.rb"
require "celerity/elements/table_elements.rb"
require "celerity/elements/table_cell.rb"
require "celerity/elements/table_row.rb"
require "celerity/elements/text_field.rb"
require "celerity/util"
require "celerity/default_viewer"
require "celerity/listener"
require "celerity/browser"
require "celerity/watir_compatibility"

# undefine deprecated methods to use them for Element attributes
Object.send :undef_method, :id   if Object.method_defined? "id"
Object.send :undef_method, :type if Object.method_defined? "type"
