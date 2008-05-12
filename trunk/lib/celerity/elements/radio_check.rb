module Celerity
  # This class is the class for radio buttons and check boxes.
  # It contains methods common to both.
  # Normally a user would not need to create this object as it is returned by the Watir::Container#checkbox or Watir::Container#radio methods
  #
  # most of the methods available to this element are inherited from the Element class
  #
  class RadioCheckCommon < InputElement
    def initialize(container, how, what, type, value = nil)
      @type = type
      @value = value
      super(container, how, what)
    end
    
    def set?
      assert_exists
      @object.isChecked
    end
    alias_method :is_set?, :set?
    alias_method :isSet?, :set?
    alias_method :get_state, :set?
    alias_method :getState, :set?
    alias_method :checked?, :set?
    
    def clear
      set(false)
    end
  end
  
  # This class is the celerity representation of a radio button.
  class Radio < RadioCheckCommon
    TAGS = [Identifier.new('input', :type => %w(radio))]

    def initialize(container, how, what, value)
      super(container, how, what, ['radio'], value)
    end

    def set(value = true)
      assert_exists
      assert_enabled
      @container.update_page(value ? @object.click : @object.setChecked(value))
    end

  end
  
  # This class is the celerity representation of a check box.
  class CheckBox < RadioCheckCommon
    TAGS = [Identifier.new('input', :type => %w(checkbox))]

    def initialize(container, how, what, value)
      super(container, how, what, ['checkbox'], value)
    end

    def set(value = true)
      assert_exists
      assert_enabled
      if (value && !set?) || (!value && set?)
        @container.update_page(@object.click)
      end
    end
  end

end
