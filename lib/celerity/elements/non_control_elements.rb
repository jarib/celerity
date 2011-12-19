module Celerity

  #
  # Superclass for for Span, Pre, Div, H1, ...
  #

  class NonControlElement < Element
    include Exception
    include ClickableElement

    ATTRIBUTES = BASE_ATTRIBUTES
    DEFAULT_HOW = :id
  end

  #
  #--
  #  classes ordered alphabetically
  #++
  #

  class Area < NonControlElement
    ATTRIBUTES = ATTRIBUTES | [
                                :accesskey,
                                :alt,
                                :coords,
                                :href,
                                :nohref,
                                :onblur,
                                :onfocus,
                                :shape,
                                :tabindex,
                              ]
    TAGS = [ Identifier.new('area') ]
  end

  class Dd < NonControlElement
    TAGS = [ Identifier.new('dd')]
  end

  class Del < NonControlElement
    TAGS = [ Identifier.new('del')]
  end

  class Div < NonControlElement
    TAGS = [ Identifier.new('div')]
  end

  class Dl < NonControlElement
    TAGS = [ Identifier.new('dl')]
  end

  class Dt < NonControlElement
    TAGS = [ Identifier.new('dt')]
  end

  class Em < NonControlElement
    TAGS = [ Identifier.new('em')]
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

  class Ins < NonControlElement
    TAGS = [ Identifier.new('ins') ]
  end

  class Li < NonControlElement
    TAGS = [ Identifier.new('li') ]
  end

  class Map < NonControlElement
    TAGS = [ Identifier.new('map') ]
  end

  class Ol < NonControlElement
    TAGS = [ Identifier.new('ol') ]
  end

  class P < NonControlElement
    TAGS = [ Identifier.new('p') ]
  end

  class Pre < NonControlElement
    TAGS = [ Identifier.new('pre')]
  end

  class Span < NonControlElement
    TAGS = [ Identifier.new('span') ]
  end

  class Strong < NonControlElement
    TAGS = [ Identifier.new('strong') ]
  end

  # class Title < NonControlElement
  #   TAGS = [ Identifier.new('title') ]
  # end

  class Ul < NonControlElement
    TAGS = [ Identifier.new('ul') ]
  end

end
