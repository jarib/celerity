module Celerity
  #
  # Class representing text field elements
  #
  # This class is the main class for Text Fields
  # Normally a user would not need to create this object as it is returned by the Watir::Container#text_field method
  class TextField < InputElement
    TAGS = [ Identifier.new('textarea'),
             Identifier.new('input', :type => ["text", "password", /^(?!(file|radio|checkbox|submit|reset|image|button|hidden)$)/])  ]
    DEFAULT_HOW = :name

    # Clear the text field.
    def clear
      assert_exists
      case @object.getTagName
      when 'textarea'
        @object.setText('')
      when 'input'
        @object.setValueAttribute('')
      end
    end

    # Set the text field to the given value.
    # This ensures execution of JavaScript events (onkeypress etc.), but is slower than +value=+
    def set(value)
      assert_enabled
      assert_not_readonly
      clear
      type_string(value.to_s)
    end

    # This directly sets the text field to the given value, skipping exectuion of JavaScript events.
    # Use +set+ if you want to run events on text fields.
    def value=(value)
      assert_enabled
      assert_not_readonly
      clear
      case @object.getTagName
      when 'textarea'
        @object.setText(value.to_s)
      when 'input'
        @object.setValueAttribute(value.to_s)
      end

      value
    end

    # Returns the text in the text field.
    def value
      assert_exists
      case @object.getTagName
      when 'textarea'
        @object.getText
      when 'input'
        @object.getValueAttribute
      end
    end
    alias_method :get_contents, :value

    # Append the given value to the text in the text field.
    def append(value)
      assert_enabled
      assert_not_readonly
      type_string(value)
    end

    def type
      assert_exists
      type = @object.getAttributeValue('type')

      if ['file', 'radio', 'checkbox', 'submit', 'reset', 'image', 'button', 'hidden'].include?(type)
        type
      else
        'text'
      end
    end

    # This bascially just moves the text to the other text field using TextField#append
    # Should check if the HtmlUnit API supports some kind of dragging.
    def drag_contents_to(how, what)
      assert_exists # assert_enabled?
      val = self.value
      self.value = ''
      @container.text_field(how, what).append(val)
    end

    # A boolean version of Container#contains_text
    # @param  [String, Regexp] expected_text The text to look for.
    # @return [boolean]
    def verify_contains(expected)
      # assert_exists called by contains_text
      !!contains_text(expected)
    end

    private

    def type_string(value)
      JavaString.new(value.to_java_bytes, @container.page.getPageEncoding).toCharArray.each do |char|
        @container.update_page @object.type(char)
      end
    end
  end

  # this class can be used to access hidden field objects
  # Normally a user would not need to create this object as it is returned by the Celerity::Container#hidden method
  class Hidden < TextField
    TAGS = [ Identifier.new('input', :type => %w[hidden]) ]
    DEFAULT_HOW = :name
  end

end
