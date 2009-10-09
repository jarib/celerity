module Celerity

  class TableCell < Element
    include Celerity::Exception
    include ClickableElement
    include Container

    TAGS = [ Identifier.new('td') ]
    ATTRIBUTES = BASE_ATTRIBUTES | CELLHALIGN_ATTRIBUTES | CELLVALIGN_ATTRIBUTES |
                 [
                   :abbr,
                   :axis,
                   :colspan,
                   :headers,
                   :rowspan,
                   :scope,
                 ]

    DEFAULT_HOW = :id

    alias_method :to_s, :text # why?

    def colspan
      assert_exists
      attribute_value = @object.getAttribute('colspan').to_i
      attribute_value > 0 ? attribute_value : 1
    end

  end

  #-- needs code review regarding attributes/correctness of this
  class Th < TableCell
    TAGS = [ Identifier.new('th')]
  end

end