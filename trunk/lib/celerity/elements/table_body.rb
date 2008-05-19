module Celerity
  class TableBody < Element
    include Enumerable # specs for this? 
    
    TAGS = [ Identifier.new('tbody') ]

    def locate
      super
      @rows = @object.getRows if @object 
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