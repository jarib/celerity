module Celerity
  class TableRow < Element
    include Enumerable
    include ClickableElement

    TAGS = [ Identifier.new('tr') ]
    DEFAULT_HOW = :id

    def locate
      super
      @cells = @object.getCells if @object
      @object
    end

    #
    # Yields each TableCell in this row to the given block.
    #

    def each
      assert_exists
      @cells.each { |cell| yield TableCell.new(self, :object, cell) }
    end

    def cells
      to_a
    end
    alias_method :tds, :cells

    #
    # Get the child cell at the given index
    #

    def child_cell(index)
      assert_exists

      if (index - Celerity.index_offset) >= @cells.length
        raise UnknownCellException, "Unable to locate a cell at index #{index}"
      end

      TableCell.new(self, :object, @cells[index - Celerity.index_offset])
    end
    alias_method :[], :child_cell

    #
    # Number of cells in this row.
    #

    def column_count
      assert_exists
      @cells.length
    end

  end # TableRow
end # Celerity
