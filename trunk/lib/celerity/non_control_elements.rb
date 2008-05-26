module Celerity
  
  # this class contains items that are common between the span, div, and pre objects
  # it would not normally be used directly
  #
  # many of the methods available to this object are inherited from the Element class
  #
  class NonControlElement < Element
    include Exception
    ATTRIBUTES = BASE_ATTRIBUTES
    DEFAULT_HOW = :id

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
  
  class Ul < NonControlElement
    TAGS = [ Identifier.new('ul') ]
  end
  
  class Ol < NonControlElement
    TAGS = [ Identifier.new('ol') ]
  end

  class Li < NonControlElement
    TAGS = [ Identifier.new('li') ]
  end
    
  class Map < NonControlElement
    TAGS = [ Identifier.new('map') ]
  end

  class Area < NonControlElement
    ATTRIBUTES = ATTRIBUTES | [:shape, :coords, :href, :nohref, :alt, :tabindex, :accesskey, :onfocus, :onblur]
    TAGS = [ Identifier.new('area') ]
  end
  
  class H1 < NonControlElement
    TAGS = [ Identifier.new('h1') ]
  end
  class H2 < NonControlElement
    TAGS = [ Identifier.new('h2') ]
  end
  class H3 < NonControlElement
    TAGS = [ Identifier.new('h3') ]
  end
  class H4 < NonControlElement
    TAGS = [ Identifier.new('h4') ]
  end
  class H5 < NonControlElement
    TAGS = [ Identifier.new('h5') ]
  end
  class H6 < NonControlElement
    TAGS = [ Identifier.new('h6') ]
  end
  
end
