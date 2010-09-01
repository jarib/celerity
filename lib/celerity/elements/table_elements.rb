module Celerity
  class TableElement < Element
    include Enumerable
    include ClickableElement

    ATTRIBUTES = BASE_ATTRIBUTES | CELLHALIGN_ATTRIBUTES | CELLVALIGN_ATTRIBUTES
    DEFAULT_HOW = :id

    def locate
      super
      @rows = @object.getRows if @object
    end

    def [](index)
      assert_exists
      TableRow.new(self, :object, @rows[index - Celerity.index_offset])
    end

    def length
      assert_exists
      @object.getRows.length
    end

    def each
      assert_exists
      @rows.each { |row| yield TableRow.new(self, :object, row) }
    end
  end

  class TableBody < TableElement
    TAGS = [ Identifier.new('tbody') ]
  end

  class TableFooter < TableElement
    TAGS = [ Identifier.new('tfoot') ]
  end

  class TableHeader < TableElement
    TAGS = [ Identifier.new('thead') ]
  end

end
