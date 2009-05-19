module Celerity

  class Label < Element
    include ClickableElement

    TAGS = [ Identifier.new('label') ]
    ATTRIBUTES = BASE_ATTRIBUTES | [:for, :accesskey, :onfocus, :onblur]
    DEFAULT_HOW = :text
  end

end