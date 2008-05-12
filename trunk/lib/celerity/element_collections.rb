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
      elsif Identifier === element_tags.first
        elems = ElementLocator.new(@container.object, element_class).elements_by_idents
        elems.size
      else
        element_tags.inject(0) { |sum, element_tag| sum + @container.object.getHtmlElementsByTagName(element_tag).toArray.size }
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