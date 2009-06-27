module Celerity
  class Meta < Element
    ATTRIBUTES  = [:name, :id, :'http-equiv', :content, :scheme] | HTML_401_TRANSITIONAL[:i18n]
    DEFAULT_HOW = :id
    TAGS = [ Identifier.new('meta') ]
  end
end
