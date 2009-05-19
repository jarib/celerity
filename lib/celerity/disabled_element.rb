module Celerity

  #
  # Mixed in to all elements that can have the 'disabled' attribute.
  #

  module DisabledElement
    include Celerity::Exception

    #
    # Returns false if the element is disabled.
    #

    def enabled?
      !disabled?
    end

    #
    # Returns true if the element is disabled.
    #

    def disabled?
      assert_exists unless defined?(@object) && @object
      @object.isDisabled
    end
    alias_method :disabled, :disabled?

    #
    # Used internally.
    # @api private
    #

    def assert_enabled
      if disabled?
        raise ObjectDisabledException, "Object #{identifier_string} is disabled"
      end
    end

  end
end