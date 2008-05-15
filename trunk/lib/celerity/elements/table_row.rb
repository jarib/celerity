module Celerity
  
  class TableRow < Element
    TAGS = [ Identifier.new('tr') ]

    def locate
      super
      @cells = @object.getCells if @object
    end

    def each
      locate
      @cells.each { |cell| yield TableCell.new(self, :object, cell) }
    end

    def [](index)
      assert_exists
      raise UnknownCellException, "Unable to locate a cell at index #{index}" if @cells.length < index
      return TableCell.new(self, :object, @cells[index-1])
    end

    def column_count
      locate
      @cells.length
    end

  end
end