require "rubygems"
require "uri"
require "active_support"

#--
# http://api.rubyonrails.com/classes/Inflector.html#M001621
#++

class String
  def underscore
     gsub(/::/, '/').
     gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
     gsub(/([a-z\d])([A-Z])/,'\1_\2').
     tr("-", "_").
     downcase
  end
end

module Celerity
  class MethodGenerator

    ELEMENTS = %w(text_field select_list radio checkbox button).map { |e| e.to_sym }
    BUGGY_ELEMENTS = %w(radio checkbox).map { |e| e.to_sym }
  
    def initialize(ie, opts = {})
      @ie = ie
      @opts = opts
      @browser = @opts[:browser] || '@ie'

      @docs = "  # Fills in the page at #{@ie.url}\n  #\n"
      @docs << "  # Parameters:\n  #\n"
      @doc_elements = []

      @method = "  def #{@opts[:method_name] || 'generated_method'}(opts = {})\n\n"
    end
  
    def parse
      ELEMENTS.each do |elem|
        @method << "    # buggy!\n" if BUGGY_ELEMENTS.include?(elem)
        add_elements(elem)
      end
      add_elements(:link) if @opts[:include_links]
      @method << "  end\n\n"

      # fix docs
      max = @doc_elements.map { |symbol, _| symbol.to_s.size }.max
      @doc_elements.each do |sym, desc|
        @docs << "  #  #{sym.to_s.ljust(max)} => #{desc}\n"
      end
      @docs << "  #\n"*2
      @docs + @method
    end
  
    private
  
    def add_elements(symbol)
      symbol = symbol.to_sym
      symbol_pluralized = symbol.to_s.pluralize.to_sym 
      @ie.send(symbol_pluralized).each_with_index do |elem, idx|
        self.send("add_#{symbol}".to_sym, elem, idx)
      end
      @method << "\n"
    end
  
    def add_text_field(elem, idx)
      how, what = find_identifier(elem) || [:index, (idx + 1).to_s]
      @method << "    #{@browser}.text_field(#{how.inspect}, #{what.inspect}).value = "
      symbol = (how == :index) ? ":text_field_#{what.underscore}" : ":#{what.underscore}"
      @method << "opts[#{symbol}]\n"
      @doc_elements << [symbol, "value for text field #{what.inspect}"]
    end
  
    def add_select_list(elem, idx)
      how, what = find_identifier(elem) || [:index, (idx + 1).to_s]
      @method << "    #{@browser}.select_list(#{how.inspect}, #{what.inspect}).select("
      symbol = (how == :index) ? ":select_list_#{what.underscore}" : ":#{what.underscore}"
      @method << "opts[#{symbol}])\n"
      @doc_elements << [symbol, "option to select for select list #{what.inspect}"]
    end
  
    def add_radio(elem, idx)
      how, what = find_identifier(elem) || [:index, (idx + 1).to_s]
      @method << "    #{@browser}.radio(#{how.inspect}, #{what.inspect}, "
      if (value = elem.value).empty?
        symbol = (how == :index) ? ":radio_#{what.underscore}" : ":#{what.underscore}"
      else
        symbol = ":#{what.underscore}_#{value.underscore}"
        @method << "#{value.inspect}).set if opts[#{symbol}]\n"
      end
      @doc_elements << [symbol, "set the radio with id/value #{what.inspect}"]
    end
  
    def add_checkbox(elem, idx)
      how, what = find_identifier(elem) || [:index, (idx + 1).to_s]
      @method << "    #{@browser}.checkbox(#{how.inspect}, #{what.inspect}, "
      symbol = (how == :index) ? ":checkbox_#{what.underscore}" : ":#{what.underscore}"
      @method << "#{elem.value.inspect}).set if opts[#{symbol}]\n"
      @doc_elements << [symbol, "set the checkbox with id/value #{what.inspect}"]
    end
  
    def add_button(elem, idx)
      how, what = find_identifier(elem) || [:index, (idx + 1).to_s]
      @method << "    #{@browser}.button(#{how.inspect}, #{what.inspect}).click\n"
    end
  
    def add_link(elem, idx)
      if (href = elem.href) =~ /javascript/
        how, what = :index, (idx + 1).to_s
      else
        how = :url
        uri = URI.parse(href)
        what = Regexp.new(Regexp.escape(uri.to_s.sub(/.*#{uri.host}\//, '')))
      end
      @method << "    #{@browser}.link(#{how.inspect}, #{what.inspect}).click\n"
    end
  
    def find_identifier(element)
      # could use these if they were 'weighted' ?
      attrs = element.class::ATTRIBUTES
      [:id, :name].each do |attribute|
        return [attribute, element.send(attribute)] if attrs.include?(attribute) && !element.send(attribute).empty?
      end
      nil
    end
  
  end # MethodGenerator
  
  class Browser
    def generate_method(opts = {})
      MethodGenerator.new(self, opts).parse
    end
  end
   
end # Celerity



# if __FILE__ == $0
#   require File.dirname(__FILE__) + "/../spec/spec_helper"
#   $stdout.sync = true
#   @ie = Browser.new
#   @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
# 
#   puts MethodGenerator.new(@ie).parse
#   @ie.goto(TEST_HOST + "/forms3.html")
#   puts MethodGenerator.new(@ie).parse
# end
