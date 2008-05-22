module Celerity
  # This class is the class for radio buttons and check boxes.
  # It contains methods common to both.
  # Normally a user would not need to create this object as it is returned by the Watir::Container#checkbox or Watir::Container#radio methods
  #
  # most of the methods available to this element are inherited from the Element class
  #
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
