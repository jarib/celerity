module Celerity

  #
  # Superclass for all HTML elements.
  #

  class Element
    include Exception
    include Container

    attr_reader :container
    attr_writer :identifier_string

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
    TAGS                  = []

    DEFAULT_HOW = nil

    # @api private
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
      when 0
        @conditions = { :index => Celerity.index_offset }
      else
        raise ArgumentError, "wrong number of arguments (#{args.size} for 2)"
      end

      @conditions.freeze
      @object = nil
    end

    def ==(other)
      return false unless other.kind_of? Element
      xpath == other.xpath
    end

    #
    # Get the parent element
    # @return [Celerity::Element, nil] subclass of Celerity::Element, or nil if no parent was found
    #

    def parent
      assert_exists

      obj = @object.parentNode
      until element_class = Celerity::Util.htmlunit2celerity(obj.class)
        return nil if obj.nil?
        obj = obj.parentNode
      end

      element_class.new(@container, :object, obj)
    end

    #
    # Sets the focus to this element.
    #

    def focus
      assert_exists
      @object.focus
    end

    #
    # Returns true if this element is the currently focused element
    #
    # Celerity-specific.
    #

    def focused?
      assert_exists
      @object == browser.page.getFocusedElement
    end

    #
    # Fires the given event for this element
    #

    def fire_event(event_name)
      assert_exists
      @object.fireEvent(event_name.sub(/^on/, ''))
    end

    #
    # Used internally. Find the element on the page.
    # @api private
    #

    def locate
      @object = ElementLocator.new(@container, self.class).find_by_conditions(@conditions)
    end

    #
    # Returns the HtmlUnit object backing this element
    #

    def object
      @object || locate
    end

    #
    # Returns a JavaScript object representing the receiver
    #
    # @api internal - subject to change
    #

    def javascript_object
      assert_exists
      @object.getScriptObject
    end

    #
    # @return [String] A string representation of the element.
    #

    def to_s
      assert_exists
      Celerity::Util.create_string @object
    end

    #
    # @param [String, #to_s] The attribute.
    # @return [String] The value of the given attribute.
    #

    def attribute_value(attribute)
      assert_exists
      @object.getAttribute attribute.to_s
    end

    #
    # Check if the element is visible to the user or not.
    # Note that this only takes the _style attribute_ of the element (and
    # its parents) into account - styles from applied CSS is not considered.
    #
    # @return [boolean]
    #

    def visible?
      assert_exists
      @object.isDisplayed
    end

    #
    # Used internally to ensure the element actually exists.
    #
    # @raise [Celerity::Exception::UnknownObjectException] if the element can't be found.
    # @api private
    #

    def assert_exists
      locate unless @object
      unless @object
        raise UnknownObjectException, "Unable to locate #{self.class.name[/::(.*)$/, 1]}, using #{identifier_string}"
      end
    end

    #
    # Checks if the element exists.
    # @return [true, false]
    #

    def exists?
      assert_exists
      true
    rescue UnknownObjectException, UnknownFrameException
      false
    end
    alias_method :exist?, :exists?

    #
    # Return a text representation of the element as it would appear in a browser.
    #
    # @see inner_text
    # @return [String]
    #

    def text
      assert_exists
      @object.asText.strip # this must behave like ElementLocator
    end

    #
    # Return the text content of this DOM node, disregarding its visibility.
    #
    # (Celerity-specific?)
    #
    # @see text
    # @return [String]
    #

    def inner_text
      assert_exists
      Celerity::Util.normalize_text @object.getTextContent
    end

    #
    # @return [String] The normative XML representation of the element (including children).
    #

    def to_xml
      assert_exists
      @object.asXml
    end
    alias_method :asXml,  :to_xml
    alias_method :as_xml, :to_xml
    alias_method :html,   :to_xml

    #
    # @return [String] A string representation of the element's attributes.
    #

    def attribute_string
      assert_exists

      result = ''
      @object.getAttributes.each do |attribute|
        result << %Q{#{attribute.getName}="#{attribute.getValue}"}
      end

      result
    end

    #
    # return the canonical xpath for this element (Celerity-specific)
    #

    def xpath
      assert_exists
      @object.getCanonicalXPath
    end

    #
    # Dynamically get element attributes.
    #
    # @see ATTRIBUTES constant for a list of valid methods for a given element.
    #
    # @return [String] The resulting attribute.
    # @raise  [NoMethodError] if the element doesn't support this attribute.
    #

    def method_missing(meth, *args, &blk)
      assert_exists

      meth = selector_to_attribute(meth)

      if self.class::ATTRIBUTES.include?(meth) || (self.class == Element && @object.hasAttribute(meth.to_s))
        return @object.getAttribute(meth.to_s)
      end
      Log.warn "Element\#method_missing calling super with #{meth.inspect}"
      super
    end

    def methods(*args)
      ms = super
      ms += self.class::ATTRIBUTES.map { |e| e.to_s }
      ms.sort
    end

    def respond_to?(meth, include_private = false)
      meth = selector_to_attribute(meth)
      return true if self.class::ATTRIBUTES.include?(meth)
      super
    end

    private

    def identifier_string
      @identifier_string ||= (
        if @conditions.size == 1
          how, what = @conditions.to_a.first
          "#{how.inspect} and #{what.inspect}"
        else
          @conditions.inspect
        end
      )
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
