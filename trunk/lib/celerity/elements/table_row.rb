module Celerity
  
  class TableRow < Element
    TAGS = [ Identifier.new('tr') ]

    def locate
      if @how == :object
        @object = @what
      else
        super
      end
      if @object # cant call the assert_exists here, as an exists? method call will fail
        @cells = @object.getCells
      end
    end

    def each
      locate
      0.upto(@cells.length-1) { |index| yield TableCell.new(self, :object, @cells[index]) }
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