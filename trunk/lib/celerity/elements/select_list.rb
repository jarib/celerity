module Celerity
  #
  # Input: Select
  #
  # This class is the way in which select boxes are manipulated
  # Normally a user would not need to create this object as it is returned by the Watir::Container#select_list method
  class SelectList < InputElement
    TAGS = [ Identifier.new('select') ]
  
    def get_all_contents
      assert_exists
      @object.getOptions.map { |e| e.asText }
    end
    alias_method :getAllContents, :get_all_contents
  
    def get_selected_items
      assert_exists
      @object.getSelectedOptions.map { |e| e.asText }
    end
    alias_method :getSelectedItems, :get_selected_items
  
    def clear_selection
      # assert_exists called by SelectList#type here
      @object.getSelectedOptions.each { |e| e.setSelected(false) } unless type() == 'select-one'
    end
    alias_method :clearSelection, :clear_selection
  
    def select(value)
      assert_exists
      raise NoValueFoundException, "unknown option with value #{value.inspect}" unless include?(value)
      @object.getOptions.select { |e| matches?(e.asText, value) }.each do |option|
        @container.update_page(option.click)
      end
    end
    alias_method :select_value, :select
    alias_method :set, :select
  
    def include?(value)
      assert_exists
      !!@object.getOptions.find { |e| matches?(e.asText, value) }
    end
    alias_method :includes?, :include?
  
    def selected?(value)
      assert_exists
      # This should probably raise NoValueFoundException as well?
      raise UnknownObjectException, "unknown option with value #{value.inspect}" unless include?(value)
      !!@object.getOptions.find { |e| matches?(e.asText, value) && e.isSelected }
    end

    def type
      assert_exists
      'select-' + (@object.isAttributeDefined('multiple') ? 'multiple' : 'one')
    end
  
    def value
      assert_exists
      if (optn = @object.getSelectedOptions.to_a.first)
        optn.getValueAttribute
      end
    end
  
    def option(attribute, value)
      assert_exists
      Option.new(self, attribute, value)
    end
  end

  class Option < Element
    TAGS = ['option']
    ATTRIBUTES = BASE_ATTRIBUTES | [:selected, :disabled, :label, :value]

    def select
      assert_exists
      # click?
      @object.setSelected(true)
    end
  
    def selected?
      assert_exists
      @object.isSelected
    end
  end
end