module Celerity
  
  # this class contains items that are common between the span, div, and pre objects
  # it would not normally be used directly
  #
  # many of the methods available to this object are inherited from the Element class
  #
  class NonControlElement < Element
    include Exception

    # Can't use ClickableElement as it does assert_enabled - maybe we don't need the module after all?
    def click
      assert_exists
      @container.update_page(@object.click)
    end

    # # These elements can't be disabled 
    # def disabled?; false; end
    # alias_method :disabled, :disabled?
  end
    
  class Pre < NonControlElement
    TAGS = ['pre']
  end
  
  class P < NonControlElement
    TAGS = ['p']
  end
  
  class Div < NonControlElement
    TAGS = ['div']   
  end
  
  class Span < NonControlElement
    TAGS = ['span']  
  end

  class Li < NonControlElement
    TAGS = ['li']    
  end
    
  class Map < NonControlElement
    TAGS = ['map']
  end

  class Area < NonControlElement
    TAGS = ['area']
  end
  
end