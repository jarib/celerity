module Celerity
  class TableRow < Element
    include Enumerable
    include ClickableElement

    TAGS = [ Identifier.new('tr') ]
    DEFAULT_HOW = :id

    def locate
      super
      @cells = @object.getCells if @object
    end

    # Yields each TableCell in this row cell to the given block.
    def each
      assert_exists
      @cells.each { |cell| yield TableCell.new(self, :object, cell) }
    end

    def child_cell(index)
      assert_exists

      if (index - INDEX_OFFSET) >= @cells.length
        raise UnknownCellException, "Unable to locate a cell at index #{index}"
      end

      TableCell.new(self, :object, @cells[index - INDEX_OFFSET])
    end
    alias_method :[], :child_cell

    def column_count
      assert_exists
      @cells.length
    end

  end
end