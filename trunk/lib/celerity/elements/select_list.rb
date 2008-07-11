module Celerity
  #
  # Input: Select
  #
  # This class is the way in which select boxes are manipulated
  # Normally a user would not need to create this object as it is returned by the Watir::Container#select_list method
  class SelectList < InputElement
    TAGS = [ Identifier.new('select') ]
    DEFAULT_HOW = :name
  
    # Returns an array strings representing the text value of the select list's options.
    def get_all_contents
      assert_exists
      @object.getOptions.map { |e| e.asText }
    end

    # Returns an array strings representing the text value of the currently selected options.  
    def get_selected_items
      assert_exists
      @object.getSelectedOptions.map { |e| e.asText }
    end
  
    # Clear all selected options
    # FIXME: should update page for each option changed?
    def clear_selection
      # assert_exists called by SelectList#type here
      @object.getSelectedOptions.each { |e| e.setSelected(false) } unless type() == 'select-one'
    end
  
    # Select the option(s) matching the given value.
    # value can be a String or Regexp.
    # 
    # If several options match the value given, all will be selected.
    def select(value)
      assert_exists
      raise NoValueFoundException, "unknown option with value #{value.inspect}" unless include?(value)
      @object.getOptions.select { |e| matches?(e.asText, value) }.each do |option|
        @container.update_page(option.click)
      end
    end
    alias_method :set, :select
  
    # Returns true if the select list has one or more options matching the given value.
    # value can be a String or Regexp.
    def include?(value)
      assert_exists
      !!@object.getOptions.find { |e| matches?(e.asText, value) }
    end
  
    # Returns true if any of the selected options match the given value.
    # value can be a String or Regexp.
    def selected?(value)
      assert_exists
      raise UnknownObjectException, "unknown option with value #{value.inspect}" unless include?(value)
      !!@object.getOptions.find { |e| matches?(e.asText, value) && e.isSelected }
    end

    # Returns 'select-multiple' if the select list has the 'multiple' attribute defined.
    # Retunrs 'select-one' otherwise.
    # TODO: Move to watir_compatibility or delete it 2008-05-23 Alexander
    def type
      assert_exists
      'select-' + (@object.isAttributeDefined('multiple') ? 'multiple' : 'one')
    end
  
    # Returns the value of the first selected option in the select list.
    # Returns nil if no option is selected.
    def value
      assert_exists
      if (optn = @object.getSelectedOptions.to_a.first)
        optn.getValueAttribute
      end
    end

  end
end