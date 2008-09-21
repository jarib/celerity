module Celerity

  # Superclass for all HTML elements.
  class Element
    include Exception
    include Container

    attr_reader :container, :object

    # number of spaces that separate the property from the value in the create_string method
    TO_S_SIZE = 14

    # HTML 4.01 Transitional DTD
    HTML_401_TRANSITIONAL = {
      :core        => [:class, :id, :style, :title],
      :cell_halign => [:align, :char, :charoff],
      :cell_valign => [:valign],
      :i18n        => [:dir, :lang],
      :event       => [:onclick, :ondblclick, :onmousedown, :onmouseup, :onmouseover,
                       :onmousemove, :onmouseout, :onkeypress, :onkeydown, :onkeyup],
      :sloppy      => [:name, :value]
    }

    CELLHALIGN_ATTRIBUTES = HTML_401_TRANSITIONAL[:cell_halign]
    CELLVALIGN_ATTRIBUTES = HTML_401_TRANSITIONAL[:cell_valign]
    BASE_ATTRIBUTES       = HTML_401_TRANSITIONAL.values_at(:core, :i18n, :event, :sloppy).flatten
    ATTRIBUTES            = BASE_ATTRIBUTES

    DEFAULT_HOW = nil

    # @api internal
    def initialize(container, *args)
      self.container = container

      case args.size
      when 2
        @conditions = { args[0] => args[1] }
      when 1
        if args.first.is_a? Hash
          @conditions = args.first
        elsif (how = self.class::DEFAULT_HOW)
          @conditions = { how => args.first }
        else
          raise ArgumentError, "wrong number of arguments (1 for 2)"
        end
      else
        raise ArgumentError, "wrong number of arguments (#{args.size} for 2)"
      end
    end

    # Get the parent element (experimental, avoid if possible)
    # @return [Celerity::Element] subclass
    def parent
      assert_exists

      obj = @object.parentNode
      until element_class = HtmlUnit2CelerityElement[obj.class]
        return nil if obj.nil?
        obj = obj.parentNode
      end

      element_class.new(@container, :object, obj)
    end

    # Sets the focus to this element.
    def focus
      assert_exists
      @object.focus
    end

    # Used internally. Find the element on the page.
    # @api internal
    def locate
      raise "BUG: no container object found when locating #{self.class} with #{identifier_string}" unless @container.object
      @object = ElementLocator.new(@container.object, self.class).find_by_conditions(@conditions)
    end

    # @return [String] A string representation of the element.
    def to_s
      assert_exists
      create_string(@object)
    end

    # @param [String, #to_s] The attribute.
    # @return [String] The value of the given attribute.
    def attribute_value(attribute)
      assert_exists
      @object.getAttribute(attribute.to_s)
    end

    # Check if the element is visible to the user or not. (Celerity-specific API)
    # Note that this only takes the _style attribute_ of this element into account -
    # styles from applied CSS is not considered.
    #
    # @return [boolean]
    def visible?
      return false if respond_to?(:type) && type == 'hidden'
      return !(style =~ /display\s*:\s*none|visibility\s*:\s*hidden/)
    end

    # Used internally to ensure the element actually exists.
    #
    # @raise Celerity::Exception::UnknownObjectException if the element can't be found.
    # @api internal
    def assert_exists
      locate
      unless @object
        raise UnknownObjectException, "Unable to locate object, using #{identifier_string}"
      end
    end

    # Checks if the element exists.
    # @return [true, false]
    def exists?
      assert_exists
      true
    rescue UnknownObjectException, UnknownFrameException
      false
    end
    alias_method :exist?, :exists?
    alias_method :exists, :exists?

    # Return a text representation of the element.
    # @return [String]
    def text
      assert_exists

      # this could work, but breaks some tests atm
      # @object.getTextContent.strip

      @object.asText.strip
    end
    alias_method :innerText,  :text
    alias_method :inner_text, :text


    # @return [String] The normative XML representation of the element (including children).
    def to_xml
      assert_exists
      @object.asXml
    end
    alias_method :asXml,  :to_xml
    alias_method :as_xml, :to_xml
    alias_method :html,   :to_xml

    # @return [String] A string representation of the element's attributes.
    def attribute_string
      assert_exists

      result = ''
      iterator = @object.getAttributeEntriesIterator

      while iterator.hasNext
        attribute = iterator.next
        result << "#{attribute.getName}=\"#{attribute.getHtmlValue.to_s}\" "
      end

      result
    end

    # Dynamically get element attributes.
    #
    # @see ATTRIBUTES constant for a list of valid methods for a given element.
    #
    # @return [String] The resulting attribute.
    # @raise NoMethodError if the element doesn't support this attribute.
    def method_missing(meth, *args, &blk)
      meth = selector_to_attribute(meth)

      if self.class::ATTRIBUTES.include?(meth)
        assert_exists
        return @object.getAttributeValue(meth.to_s)
      end

      Log.warn "Element\#method_missing calling super with #{meth.inspect}"
      super
    end

    def respond_to?(meth, include_private = false)
      meth = selector_to_attribute(meth)
      return true if self.class::ATTRIBUTES.include?(meth)
      super
    end

    private

    def create_string(element)
      ret = []
      ret << "tag:".ljust(TO_S_SIZE) + element.getTagName unless element.getTagName.empty?

      iterator = element.getAttributeEntriesIterator
      while iterator.hasNext
        attribute = iterator.next
        ret << "  #{attribute.getName}:".ljust(TO_S_SIZE+2) + attribute.getHtmlValue.to_s
      end

      ret << "  text:".ljust(TO_S_SIZE+2) + element.asText unless element.asText.empty?

      ret.join("\n")
    end

    def identifier_string
      if @conditions.size == 1
        how, what = @conditions.shift
        "#{how.inspect} and #{what.inspect}"
      else
        @conditions.inspect
      end
    end

    def selector_to_attribute(meth)
      case meth
      when :class_name then :class
      when :caption    then :value
      when :url        then :href
      else meth
      end
    end

  end # Element
end # Celerity
