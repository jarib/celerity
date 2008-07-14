module Celerity
  # this class is the super class for the iterator classes (buttons, links, spans etc
  # it would normally only be accessed by the iterator methods (spans, links etc) of Browser
  class ElementCollections
    include Enumerable
    
    def initialize(container, how = nil, what = nil)
      @container = container
      @object = (how == :object ? what : nil)
      @length = length
    end
   
    def length
      if @object
        @object.length
      else
        @elements ||= ElementLocator.new(@container.object, element_class).elements_by_idents
        @elements.size
      end
    end
    alias_method :size, :length
    
    def each
      if @elements
        @elements.each { |e| yield(element_class.new(@container, :object, e)) }
        @length
      else
        0.upto(@length - 1) { |i| yield iterator_object(i) }
      end
    end
    
    def [](n)
      @elements ? element_class.new(@container, :object, @elements[n-1]) : iterator_object(n-1)
    end
    
    def to_s
      map { |e| e.to_s }.join("\n")
    end
    
    private

    def iterator_object(i)
      element_class.new(@container, :index, i+1)
    end
  
  end # ElementCollections
end # Celerity