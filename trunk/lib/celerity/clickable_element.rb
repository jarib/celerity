module Celerity
  module ClickableElement
    
    def click
      assert_exists
      assert_enabled
      @container.update_page(@object.click)
    end 
    
  end
end