module Celerity
  # Common superclass for radios and check boxes.
  class RadioCheckCommon < InputElement
    DEFAULT_HOW = :name
    
    def initialize(container, type, *args)
      @type = type
      case args.size
      when 2
        super(container, args[0] => args[1])
      when 3
        super(container, args[0] => args[1], :value => args[2])
      else
        super(container, *args)
      end
    end
    
    # returns true if the element is checked
    def set?
      assert_exists
      @object.isChecked
    end
    alias_method :checked?, :set?
    
    def clear
      set(false)
    end
  end
  
  # This class is the celerity representation of a radio button.
  class Radio < RadioCheckCommon
    TAGS = [Identifier.new('input', :type => %w(radio))]

    def initialize(container, *args)
      super(container, ['radio'], *args)
    end

    # Sets the radio button. 
    #
    #   radio.set? # => false
    #   radio.set  
    #   radio.set? # => true
    #   radio.set(false)
    #   radio.set? # => false
    def set(value = true)
      assert_exists
      assert_enabled
      @container.update_page(value ? @object.click : @object.setChecked(value))
    end

  end
  
  # This class is the celerity representation of a check box.
  class CheckBox < RadioCheckCommon
    TAGS = [Identifier.new('input', :type => %w(checkbox))]

    def initialize(container, *args)
      super(container, ['checkbox'], *args)
    end

    # Sets the checkbox button. 
    #
    #   checkbox.set? # => false
    #   checkbox.set  
    #   checkbox.set? # => true
    #   checkbox.set(false)
    #   checkbox.set? # => false
    def set(value = true)
      assert_exists
      assert_enabled
      if (value && !set?) || (!value && set?)
        Log.debug(@object.inspect)
        @container.update_page(@object.click)
      end
    end
  end

end
