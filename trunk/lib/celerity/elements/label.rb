module Celerity
  
  class Label < Element
    TAGS = ['label']
    ATTRIBUTES = BASE_ATTRIBUTES | [:for, :accesskey, :onfocus, :onblur]
    
    
  end
  
end