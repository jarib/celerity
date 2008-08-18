module Celerity
  class Link < Element
    
    TAGS = [ Identifier.new('a') ]
    ATTRIBUTES = BASE_ATTRIBUTES | [:charset, :type, :name, :href, :hreflang, 
                                    :target, :rel, :rev, :accesskey, :shape, 
                                    :coords, :tabindex, :onfocus, :onblur]
    DEFAULT_HOW = :href
    
    # clicks the link
    def click
      assert_exists
      @container.update_page @object.click
    end
    
  end
  
end