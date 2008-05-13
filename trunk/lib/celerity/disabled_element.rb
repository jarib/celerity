module Celerity
  module DisabledElement
    def enabled?
      !disabled?
    end

    def disabled?
      assert_exists unless @object
      @object.isDisabled
    end
    alias_method :disabled, :disabled?
    
    def assert_enabled
      if disabled?
        raise ObjectDisabledException, "Object #{@how.inspect} and #{@what.inspect} is disabled"
      end
    end
    
  end
end