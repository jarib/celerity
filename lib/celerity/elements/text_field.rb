module Celerity

  #
  # Class representing text field elements
  #
  # This class is the main class for Text Fields
  # Normally a user would not need to create this object as it is returned by the Watir::Container#text_field method
  #

  class TextField < InputElement
    NON_TEXT_TYPES = %w[file radio checkbox submit reset image button hidden]
    TAGS = [ Identifier.new('textarea'),
             Identifier.new('input', :type => ["text", "password", /^(?!(#{ Regexp.union(*NON_TEXT_TYPES) })$)/])  ]
    DEFAULT_HOW = :name

    def visible?
      assert_exists
      type == 'hidden' ? false : super
    end

    #
    # Clear the text field.
    #

    def clear
      assert_exists
      insert_string ''
    end

    #
    # Set the text field to the given value.
    # This ensures execution of JavaScript events (onkeypress etc.), but is slower than +value=+
    #

    def set(value)
      assert_enabled
      assert_not_readonly
      clear
      type_string(value.to_s)

      value
    end

    #
    # This directly sets the text field to the given value, skipping exectuion of JavaScript events.
    # Use +set+ if you want to run events on text fields.
    #

    def value=(value)
      assert_enabled
      assert_not_readonly
      clear

      insert_string value.to_s

      value
    end

    #
    # Returns the text in the text field.
    #

    def value
      assert_exists
      case @object.getTagName
      when 'textarea'
        @object.getText
      when 'input'
        @object.getValueAttribute
      end
    end

    #
    # Append the given value to the text in the text field.
    #

    def append(value)
      assert_enabled
      assert_not_readonly
      type_string value
    end


    def type
      assert_exists
      type = @object.getAttribute 'type'

      NON_TEXT_TYPES.include?(type) ? type : 'text'
    end

    #
    # This bascially just moves the text to the other text field using TextField#append
    # TODO: check if HtmlUnit supports some kind of dragging.
    #

    def drag_contents_to(how, what)
      assert_exists # assert_enabled?
      val = self.value
      self.value = ''
      @container.text_field(how, what).append(val)
    end

    #
    # Check if the given text fields contains the given String or Regexp.
    #

    def contains_text(expected_text)
      assert_exists

      case expected_text
      when Regexp
        value() =~ expected_text
      when String
        value().index(expected_text)
      else
        raise TypeError, "expected String or Regexp, got #{expected_text.inspect}:#{expected_text.class}"
      end
    end

    #
    # A boolean version of TextField#contains_text
    #
    # @param  [String, Regexp] expected_text The text to look for.
    # @return [boolean]
    #

    def verify_contains(expected)
      # assert_exists called by contains_text
      !!contains_text(expected)
    end

    private

    def type_string(value)
      java.lang.String.new(value.to_java_bytes, @browser.page.getPageEncoding).toCharArray.each do |char|
        @object.type(char)
      end
    end

    def insert_string(value)
      case @object.getTagName
      when 'textarea'
        @object.setText(value)
      when 'input'
        @object.setValueAttribute(value)
      else
        raise "unknown tag name #{@object.getTagName.inspect} for #{self.class}"
      end
    end

  end # TextField

  #
  # This class can be used to access hidden field objects
  # Normally a user would not need to create this object as it is returned by the Celerity::Container#hidden method
  #

  class Hidden < TextField
    TAGS = [ Identifier.new('input', :type => %w[hidden]) ]
    DEFAULT_HOW = :name

    def visible?
      assert_exists
      false
    end
  end

end # Celerity
