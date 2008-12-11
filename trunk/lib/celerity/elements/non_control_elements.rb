module Celerity

  # Superclass for for Span, Pre, Div, H1, ...
  class NonControlElement < Element
    include Exception
    include ClickableElement

    ATTRIBUTES = BASE_ATTRIBUTES
    DEFAULT_HOW = :id
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
  
  class Dl < NonControlElement
    TAGS = [ Identifier.new('dl')]
  end

  class Dt < NonControlElement
    TAGS = [ Identifier.new('dt')]
  end

  class Dd < NonControlElement
    TAGS = [ Identifier.new('dd')]
  end

  class Map < NonControlElement
    TAGS = [ Identifier.new('map') ]
  end
  
  class Meta < NonControlElement
    ATTRIBUTES = [:name, :id, :'http-equiv', :content, :scheme] | HTML_401_TRANSITIONAL[:i18n]
    TAGS = [ Identifier.new('meta') ]
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
