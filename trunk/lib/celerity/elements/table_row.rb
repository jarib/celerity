module Celerity
  class TableRow < Element
    include Enumerable # specs for this?
    
    TAGS = [ Identifier.new('tr') ]
    DEFAULT_HOW = :id

    def locate
      super
      @cells = @object.getCells if @object
    end

    def each
      assert_exists
      @cells.each { |cell| yield TableCell.new(self, :object, cell) }
    end

    def [](index)
      assert_exists
      raise UnknownCellException, "Unable to locate a cell at index #{index}" if @cells.length < index
      return TableCell.new(self, :object, @cells[index-1])
    end

    def column_count
      assert_exists
      @cells.length
    end

  end
end