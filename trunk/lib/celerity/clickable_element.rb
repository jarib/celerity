module Celerity
  module ClickableElement
    
    # clicks the element
    def click
      assert_exists
      assert_enabled if respond_to?(:assert_enabled)
      @container.update_page(@object.click)
    end
    
  end
end