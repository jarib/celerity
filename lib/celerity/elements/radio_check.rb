module Celerity

  #
  # Common superclass for radios and check boxes.
  #

  class RadioCheckCommon < InputElement
    DEFAULT_HOW = :name

    #
    # Can optionally take a value parameter as a third arg, so we override initialize
    #

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

    #
    # returns true if the element is checked
    # @return [true, false]
    #

    def set?
      assert_exists
      @object.isChecked
    end
    alias_method :checked?, :set?

    #
    # Unset this element.
    #

    def clear
      set(false)
    end
  end

  #
  # This class is the representation of a radio button.
  #

  class Radio < RadioCheckCommon
    TAGS = [Identifier.new('input', :type => %w[radio])]

    #
    # @api private
    #

    def initialize(container, *args)
      super(container, %w[radio], *args)
    end

    #
    # Set the radio button to the given value.
    #
    #   radio.set?        #=> false
    #   radio.set
    #   radio.set?        #=> true
    #   radio.set(false)
    #   radio.set?        #=> false
    #

    def set(value = true)
      assert_exists
      assert_enabled
      value ? @object.click : @object.setChecked(value)
    end

  end

  #
  # This class is the representation of a check box.
  #

  class CheckBox < RadioCheckCommon
    TAGS = [Identifier.new('input', :type => %w[checkbox])]

    #
    # @api private
    #

    def initialize(container, *args)
      super(container, %w[checkbox], *args)
    end

    #
    # Set the checkbox to the given value.
    #
    #   checkbox.set?         #=> false
    #   checkbox.set
    #   checkbox.set?         #=> true
    #   checkbox.set(false)
    #   checkbox.set?         #=> false
    #

    def set(value = true)
      assert_exists
      assert_enabled

      if (value && !set?) || (!value && set?)
        @object.click
      end
    end
  end

end
