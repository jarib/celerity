module Celerity
  module DisabledElement
    include Celerity::Exception
    
    def enabled?
      !disabled?
    end

    def disabled?
      assert_exists unless defined?(@object) && @object
      @object.isDisabled
    end
    alias_method :disabled, :disabled?
    
    def assert_enabled
      if disabled?
        raise ObjectDisabledException, "Object #{identifier_string} is disabled"
      end
    end
    
  end
end