module Celerity
  class Element
    include Exception
    include Container
    attr_accessor :container, :object
    
    # number of spaces that separate the property from the value in the create_string method
    TO_S_SIZE = 14
    
    # HTML 4.01 Transitional DTD
    HTML_401_TRANSITIONAL = { 
      :core        => [:class, :id, :style, :title],
      :cell_halign => [:align, :char, :charoff],
      :cell_valign => [:valign],
      :i18n        => [:dir, :lang],
      :event       => [:onclick, :ondblclick, :onmousedown, :onmouseup, :onmouseover, :onmousemove, :onmouseout, :onkeypress, :onkeydown, :onkeyup],
      :sloppy      => [:name, :value]
    }
    
    CELLHALIGN_ATTRIBUTES = HTML_401_TRANSITIONAL[:cell_halign]
    CELLVALIGN_ATTRIBUTES = HTML_401_TRANSITIONAL[:cell_valign]
    BASE_ATTRIBUTES       = HTML_401_TRANSITIONAL.values_at(:core, :i18n, :event, :sloppy).flatten
    ATTRIBUTES            = BASE_ATTRIBUTES

    DEFAULT_HOW = nil
    
    def initialize(container, *args)
      set_container container
      
      case args.size
      when 2
        @conditions = { args[0] => args[1] }
      when 1
        if Hash === args.first
          @conditions = args.first
        elsif self.class::DEFAULT_HOW
          @conditions = { self.class::DEFAULT_HOW => args.first }
        else
          raise ArgumentError, "wrong number of arguments (1 for 2)"
        end
      else
        raise ArgumentError, "wrong number of arguments (#{args.size} for 2)"
      end
    end
    
    def locate
      @object = ElementLocator.new(@container.object, self.class).find_by_conditions(@conditions)
    end
    
    def to_s
      assert_exists
      create_string(@object)
    end
    
    def attribute_value(attribute)
      assert_exists
      @object.getAttribute(attribute)
    end

    def assert_exists
      locate
      unless @object
        raise UnknownObjectException, "Unable to locate object, using #{identifier_string}"
      end
    end

    def exists?
      begin
        assert_exists
        true
      rescue UnknownObjectException, UnknownFrameException
        false
      end
    end
    alias_method :exist?, :exists?
    alias_method :exists, :exists?

    def text
      assert_exists
      @object.asText.strip
    end
    alias_method :innerText, :text
    alias_method :inner_text, :text

    def contains_text(expected_text)
      assert_exists
      case expected_text
      when Regexp
        text().match(expected_text)
      when String
        text().index(expected_text)
      else
        raise ArgumentError, "Argument #{expected_text.inspect} should be a String or Regexp."
      end
    end

    def to_xml
      assert_exists
      @object.asXml
    end
    alias_method :asXml, :to_xml
    alias_method :as_xml, :to_xml
    alias_method :html, :to_xml
    
    def attribute_string
      assert_exists
      n = ''
      iterator = @object.getAttributeEntriesIterator
      while iterator.hasNext
        attribute = iterator.next
        n += "#{attribute.getName}=\"#{attribute.getHtmlValue.to_s}\" "
      end
      return n
    end

    # used to get attributes
    def method_missing(meth, *args, &blk)
      meth = method_to_attribute(meth)
      
      if self.class::ATTRIBUTES.include?(meth)
        assert_exists
        @object.getAttributeValue(meth.to_s)
      else
        Log.warn "Element\#method_missing calling super with #{meth.inspect}"
        super
      end
    end

    def respond_to?(meth, include_private = false)
      meth = method_to_attribute(meth)
      return true if self.class::ATTRIBUTES.include?(meth)
      super
    end

    private
    
    def create_string(element)
      n = []
      n << "tag:".ljust(TO_S_SIZE) + element.getTagName unless element.getTagName.empty?
      iterator = element.getAttributeEntriesIterator
      while iterator.hasNext
        attribute = iterator.next
        n << "  #{attribute.getName}:".ljust(TO_S_SIZE+2) + attribute.getHtmlValue.to_s
      end
      n << "  text:".ljust(TO_S_SIZE+2) + element.asText unless element.asText.empty?
      return n.join("\n")
    end
    
    def identifier_string
      if @conditions.size == 1
        how, what = @conditions.shift
        "#{how.inspect} and #{what.inspect}"
      else
        @conditions.inspect
      end
    end
    
    def method_to_attribute(meth)
      case meth
      when :class_name then :class
      when :caption then :value
      when :url then :href
      else meth
      end
    end
    
  end # Element
end # Celerity
