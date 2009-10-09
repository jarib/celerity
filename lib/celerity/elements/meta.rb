module Celerity
  class Meta < Element
    ATTRIBUTES  = HTML_401_TRANSITIONAL[:i18n] | [
                                                    :'http-equiv',
                                                    :content,
                                                    :id,
                                                    :name,
                                                    :scheme,
                                                   ]

    DEFAULT_HOW = :id
    TAGS = [ Identifier.new('meta') ]
  end
end
