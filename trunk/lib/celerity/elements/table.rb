module Celerity

  class Table < Element
    include Enumerable # specs for this?
    include Container
    
    TAGS = [ Identifier.new('table') ]
    ATTRIBUTES = BASE_ATTRIBUTES | [:summary, :width, :border, :frame, :rules, :cellspacing, :cellpadding, :align, :bgcolor]
    DEFAULT_HOW = :id
    
    def locate
      super
      if @object # cant call assert_exists here, as an exists? method call will fail
        @rows = @object.getRows
        @cells = []
        @rows.each do |row| 
          row.getCells.each do |c|
            @cells << c
          end 
        end
      end
    end
    
    def rows
      assert_exists
      return TableRows.new(self, :object, @rows)
    end
    
    def cells
      assert_exists
      return TableCells.new(self, :object, @cells)
    end
    
    def each
      assert_exists
      @rows.each { |row| yield TableRow.new(self, :object, row)  }
    end
    
    def child_row(index)
      assert_exists
      raise UnknownRowException, "Unable to locate a row at index #{index}" if @cells.length < index
      return TableRow.new(self, :object, @rows[index-1])
    end
    alias_method :[], :child_row
    
    def child_cell(index)
      assert_exists
      raise UnknownCellException, "Unable to locate a cell at index #{index}" if @cells.length < index
      return TableCell.new(self, :object, @cells[index-1])
    end
    
    def row_count
      assert_exists
      @object.getRowCount
    end
    
    def column_count(index = 1)
      assert_exists
      @object.getRow(index-1).getCells.length
    end
    
    # This method returns the table as a 2 dimensional array.
    # Raises an UnknownObjectException if the table doesn't exist.
    def to_a
      assert_exists
      y = []
      table_rows = @object.getRows
      for table_row in table_rows
        x = []
        for td in table_row.getCells
          x << td.asText
        end
        y << x
      end
      return y
    end
    
    def column_values(columnnumber)
      (1..row_count).collect { |index| self[index][columnnumber].text }
    end
    
    def row_values(rownumber)
      (1..column_count(rownumber)).collect { |index| self[rownumber][index].text }
    end

  end
  
end