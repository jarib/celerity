module Celerity
  class SelectList < InputElement
    TAGS = [ Identifier.new('select') ]
    DEFAULT_HOW = :name

    #
    # @return [Array<String>] An array of strings representing the text value of the select list's options.
    #

    def options
      assert_exists
      @object.getOptions.map { |e| e.asText.empty? ? e.getLabelAttribute : e.asText }
    end

    #
    # @return [Array<String>] An array of strings representing the text value of the currently selected options.
    #

    def selected_options
      assert_exists
      @object.getSelectedOptions.map { |e| e.asText.empty? ? e.getLabelAttribute : e.asText }
    end

    #
    # Clear all selected options
    #

    def clear
      @object.getSelectedOptions.each { |e| e.setSelected(false) } if multiple?
    end

    #
    # Select the option(s) whose text or label matches the given string.
    # If several options match the value given, all will be selected.
    #
    # @param [String, Regexp] value A value.
    # @raise [Celerity::Exception::NoValueFoundException] if the value does not exist.
    # @return [String] The option selected. If multiple options match, returns the first match
    #
    #

    def select(value)
      assert_exists

      selected = nil
      @object.getOptions.select do |option|
        next unless matches_option?(option, value)

        selected ||= option.asText
        option.click unless option.isSelected
      end

      unless selected
        raise NoValueFoundException, "unknown option with value #{value.inspect} for select_list #{@conditions.inspect}"
      end

      selected
    end
    alias_method :set, :select

    #
    # Selects the option(s) whose value attribute matches the given string.
    # @param [String, Regexp] value A value.
    # @raise [Celerity::Exception::NoValueFoundException] if the value does not exist.
    # @return [String] The option selected. If multiple options match, returns the first match
    #

    def select_value(value)
      assert_exists
      selected = @object.getOptions.map { |e| e.click if Util.matches?(e.getValueAttribute, value) }.compact.first

      unless selected
        raise NoValueFoundException, "unknown option with value #{value.inspect} for select_list #{@conditions.inspect}"
      end

      selected.asText
    end

    #
    # Returns true if the select list has one or more options matching the given value.
    #
    # @param [String, Regexp] value A value.
    # @return [true, false]
    #

    def include?(value)
      assert_exists
      !!@object.getOptions.find { |e| matches_option?(e, value) }
    end

    #
    # Returns true if any of the selected options match the given value.
    #
    # @param [String, Regexp] value A value.
    # @raise [Celerity::Exception::UnknownObjectException] if the value does not exist.
    # @return [true, false]
    #

    def selected?(value)
      assert_exists
      raise UnknownObjectException, "unknown option with value #{value.inspect} for select_list #{@conditions.inspect}" unless include?(value)
      !!@object.getOptions.find { |e| matches_option?(e, value) && e.isSelected }
    end

    #
    # Returns 'select-multiple' if the select list has the 'multiple' attribute,
    # defined, otherwise 'select-one'.
    #
    # @return [String]
    #

    def type
      assert_exists
      'select-' + (@object.hasAttribute('multiple') ? 'multiple' : 'one')
    end

    #
    # Returns true if the select list supports multiple selections
    #

    def multiple?
      type == "select-multiple"
    end

    #
    # Returns the value of the first selected option in the select list.
    # Returns nil if no option is selected.
    #
    # @return [String, nil]
    #

    def value
      assert_exists
      if (option = @object.getSelectedOptions.to_a.first)
        option.getValueAttribute
      end
    end

    private

    def matches_option?(option, value)
      Util.matches?(option.asText, value) || (option.hasAttribute("label") && Util.matches?(option.getLabelAttribute, value))
    end

  end # SelectList
end # Celerity
