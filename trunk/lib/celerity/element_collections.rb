module Celerity
  # This class is the superclass for the iterator classes (Buttons, Links, Spans etc.)
  # It would normally only be accessed by the iterator methods (Browser#spans, Browser#links, ...).
  class ElementCollections
    include Enumerable

    # @api private
    def initialize(container, how = nil, what = nil)
      @container = container
      @object = (how == :object ? what : nil)
      @length = length
    end

    # @return [Fixnum] The number of elements in this collection.
    def length
      if @object
        @object.length
      else
        @elements ||= ElementLocator.new(@container.object, element_class).elements_by_idents
        @elements.size
      end
    end
    alias_method :size, :length

    # @yieldparam [Celerity::Element] element Iterate through the elements in this collection.
    #
    def each
      if @elements
        @elements.each { |e| yield(element_class.new(@container, :object, e)) }
        @length
      else
        0.upto(@length - 1) { |i| yield iterator_object(i) }
      end
    end

    # Get the element at the given index.
    # NB! This is 1-indexed to keep compatibility with Watir. Subject to change.
    #
    # @param [Fixnum] n Index of wanted element, 1-indexed.
    # @return [Celerity::Element, nil] Returns nil if index is out of bounds.
    def [](n)
      if @elements && @elements[n-1]
        element_class.new(@container, :object, @elements[n-1])
      else
        iterator_object(n-1)
      end
    end

    # Note: This can be quite useful in irb:
    #
    #   puts browser.text_fields
    #
    # @return [String] A string representation of all elements in this collection.
    def to_s
      map { |e| e.to_s }.join("\n")
    end

    private

    def iterator_object(i)
      element_class.new(@container, :index, i+1)
    end

  end # ElementCollections
end # Celerity