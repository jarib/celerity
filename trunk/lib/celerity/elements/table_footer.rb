module Celerity
  class TableFooter < Element
    include Enumerable # specs for this? 
    
    TAGS = [ Identifier.new('tfoot') ]
    ATTRIBUTES = BASE_ATTRIBUTES | CELLHALIGN_ATTRIBUTES | CELLVALIGN_ATTRIBUTES
    DEFAULT_HOW = :id

    def locate
      super
      @rows = @object.getRows if @object 
    end

    def [](index)
      assert_exists
      TableRow.new(self, :object, @rows[index-1])
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
end