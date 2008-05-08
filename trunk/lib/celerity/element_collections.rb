module Celerity
  # this class is the super class for the iterator classes (buttons, links, spans etc
  # it would normally only be accessed by the iterator methods (spans, links etc) of IE
  class ElementCollections
    include Enumerable
    
    def element_tags
      element_class::TAGS
    end
    
    def length
      if @object
        @object.length
      elsif Element::Identifier === element_tags.first
        idents = element_tags
        tags   = idents.map { |e| e.tag }    
        tags.map! { |t| t.downcase }
        elements = @container.object.getAllHtmlChildElements.iterator.to_a.select do |elem|
          tags.include?(elem.getTagName)
        end
        elements = elements.select do |e| 
          idents.any? do |ident| 
            next unless ident.tag == e.getTagName
            if ident.attributes.empty?
              true
            else
              ident.attributes.any? { |key, value| value.include?(e.getAttributeValue(key.to_s)) } 
            end
          end
        end
        return elements.length
      else
        length = 0
        element_tags.each { |element_tag| length += @container.object.getHtmlElementsByTagName(element_tag).toArray.size }
        return length
      end
    end
    alias_method :size, :length
    
    def initialize(container, how = nil, what = nil)
      @container = container
      if how == :object
        @object = what
      end
      @length = length # defined by subclasses
    end
    
    def each
      0.upto(@length-1) { |i| yield iterator_object(i) }
    end
    
    def [](n)
      return iterator_object(n-1)
    end
    
    def to_s
      return self.collect { |i| i.to_s }.join("\n")
    end
    
    # this method creates an object of the correct type that the iterators use
    private
    def iterator_object(i)
      element_class.new(@container, :index, i+1)
    end
  
  end # ElementCollections
end # Celerity