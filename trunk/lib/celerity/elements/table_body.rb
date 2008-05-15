module Celerity
  
  class TableBody < Element
    TAGS = [ Identifier.new('tbody') ]

    def locate
      super
      # can't call the assert_exists here, as an exists? method call will fail
      if @object 
        @rows = @object.getRows
        @cells = []
        @rows.each do |row| 
          row.getCells.each do |c|
            @cells << c
          end 
        end
      end
    end

    def [](index)
      assert_exists
      return TableRow.new(self, :object, @rows[index-1])
    end

    def length
      assert_exists
      return @object.getRows.length
    end
    
    def each
      assert_exists
      @rows.each { |row| yield TableRow.new(self, :object, row) }
    end

  end
end