module Celerity

  class Table < Element
    include Container
    TAGS = [ Identifier.new('table') ]
    ATTRIBUTES = BASE_ATTRIBUTES | [:summary, :width, :border, :frame, :rules, :cellspacing, :cellpadding, :align, :bgcolor]
    DEFAULT_HOW = :name
    
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
      0.upto(@object.getRowCount-1) { |index| yield TableRow.new(self, :object, @rows[index]) }
    end
    
    def [](index)
      assert_exists
      return TableRow.new(self, :object, @rows[index-1])
    end
    
    def row_count
      assert_exists
      @object.getRowCount
    end
    
    def column_count(index = 1)
      assert_exists
      @object.getRow(index-1).getCells.length
    end
    
    # This method returns the table as a 2 dimensional array. Dont expect too much if there are nested tables, colspan etc.
    # Raises an UnknownObjectException if the table doesn't exist.
    # http://www.w3.org/TR/html4/struct/tables.html
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
    
    def table_body(index = 1)
      return @object.getBodies.get(index)
    end
    private :table_body
    
    def body(how, what)
      assert_exists
      return TableBody.new(@container, how, what, self)
    end
    
    def bodies
      assert_exists
      return TableBodies.new(self)
    end
    
    def column_values(columnnumber)
      return (1..row_count).collect { |index| self[index][columnnumber].text }
    end
    
    def row_values(rownumber)
      return (1..column_count(rownumber)).collect { |index| self[rownumber][index].text }
    end
    
  end
  
end