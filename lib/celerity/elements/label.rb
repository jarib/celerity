module Celerity

  class Label < Element
    include ClickableElement

    TAGS = [ Identifier.new('label') ]
    ATTRIBUTES = BASE_ATTRIBUTES | [
                                      :accesskey,
                                      :for,
                                      :onblur,
                                      :onfocus,
                                    ]
    DEFAULT_HOW = :text
  end

end