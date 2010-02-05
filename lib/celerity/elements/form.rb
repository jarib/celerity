module Celerity
  class Form < Element
    include Container

    TAGS = [Identifier.new('form')]

    # HTML 4.01 Transitional DTD
    ATTRIBUTES = BASE_ATTRIBUTES | [
                                      :'accept-charset',
                                      :accept,
                                      :action,
                                      :enctype,
                                      :method,
                                      :name,
                                      :onreset,
                                      :onsubmit,
                                      :target,
                                    ]
    DEFAULT_HOW = :name

  end # Form
end # Celerity