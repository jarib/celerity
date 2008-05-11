module Celerity
  
  class TableCell < Element
    include Celerity::Exception
    include Container

    TAGS = [ Identifier.new('td') ]
    ATTRIBUTES = BASE_ATTRIBUTES | [:abbr, :axis, :headers, :scope, :rowspan, :colspan] | CELLHALIGN_ATTRIBUTES | CELLVALIGN_ATTRIBUTES
    
    def locate
      if @how == :object
        @object = @what
      else
          @object = @container.locate_tagged_element(self, @how, @what)
      end
    end

    def colspan
      assert_exists
      attribute_value = @object.getAttributeValue('colspan').to_i
      if attribute_value > 0
        attribute_value
      else
        1
      end
    end

    alias_method :to_s, :text
  end
end