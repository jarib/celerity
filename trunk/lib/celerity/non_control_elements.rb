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
  end
    
  class Pre < NonControlElement
    TAGS = [ Identifier.new('pre')] 
  end
  
  class P < NonControlElement
    TAGS = [ Identifier.new('p') ]
  end
  
  class Div < NonControlElement
    TAGS = [ Identifier.new('div')] 
  end
  
  class Span < NonControlElement
    TAGS = [ Identifier.new('span') ]
  end

  class Li < NonControlElement
    TAGS = [ Identifier.new('li') ]
  end
    
  class Map < NonControlElement
    TAGS = [ Identifier.new('map') ]
  end

  class Area < NonControlElement
    TAGS = [ Identifier.new('area') ]
  end
  
end