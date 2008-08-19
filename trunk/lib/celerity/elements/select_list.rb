module Celerity
  class SelectList < InputElement
    TAGS = [ Identifier.new('select') ]
    DEFAULT_HOW = :name
  
    # @return [Array<String>] An array of strings representing the text value of the select list's options.
    def get_all_contents
      assert_exists
      @object.getOptions.map { |e| e.asText }
    end

    # @return [Array<String>] An array of strings representing the text value of the currently selected options.  
    def get_selected_items
      assert_exists
      @object.getSelectedOptions.map { |e| e.asText }
    end
  
    # Clear all selected options
    # TODO: should update page for each option changed?
    def clear_selection
      # assert_exists called by SelectList#type here
      @object.getSelectedOptions.each { |e| e.setSelected(false) } unless type() == 'select-one'
    end
  
    # Select the option(s) matching the given value.
    # If several options match the value given, all will be selected.
    #
    # @param [String, Regexp] value A value.
    # @raise Celerity::Exception::NoValueFoundException if the value does not exist.
    def select(value)
      assert_exists
      raise NoValueFoundException, "unknown option with value #{value.inspect}" unless include?(value)
      @object.getOptions.select { |e| matches?(e.asText, value) }.each do |option|
        @container.update_page(option.click)
      end
    end
    alias_method :set, :select
  
    # Returns true if the select list has one or more options matching the given value.
    # 
    # @param [String, Regexp] value A value.
    # @return [true, false]
    def include?(value)
      assert_exists
      !!@object.getOptions.find { |e| matches?(e.asText, value) }
    end
  
    # Returns true if any of the selected options match the given value.
    #
    # @param [String, Regexp] value A value.
    # @raise Celerity::Exception::UnknownObjectException if the value does not exist.
    # @return [true, false]
    def selected?(value)
      assert_exists
      raise UnknownObjectException, "unknown option with value #{value.inspect}" unless include?(value)
      !!@object.getOptions.find { |e| matches?(e.asText, value) && e.isSelected }
    end

    # Returns 'select-multiple' if the select list has the 'multiple' attribute,
    # defined, otherwise 'select-one'.
    #
    # @return [String]
    # TODO: Move to watir_compatibility or delete it 2008-05-23 Alexander
    def type
      assert_exists
      'select-' + (@object.isAttributeDefined('multiple') ? 'multiple' : 'one')
    end
  
    # Returns the value of the first selected option in the select list.
    # Returns nil if no option is selected.
    #
    # @return [String, nil]
    def value
      assert_exists
      if (optn = @object.getSelectedOptions.to_a.first)
        optn.getValueAttribute
      end
    end

  end
end