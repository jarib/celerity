module Celerity

  #
  # This class is the superclass for the iterator classes (Buttons, Links, Spans etc.)
  # It would normally only be accessed by the iterator methods (Browser#spans, Browser#links, ...).
  #

  class ElementCollection
    include Enumerable

    #
    # @api private
    #

    def initialize(container, how = nil, what = nil)
      @container = container
      @object = (how == :object ? what : nil)
      @length = length
    end

    #
    # @return [Fixnum] The number of elements in this collection.
    #

    def length
      if @object
        @object.length
      else
        @elements ||= ElementLocator.new(@container, element_class).elements_by_idents
        @elements.size
      end
    end
    alias_method :size, :length

    #
    # Returns true if the collection is empty.
    #

    def empty?
      length == 0
    end

    #
    # @yieldparam [Celerity::Element] element Iterate through the elements in this collection.
    #

    def each
      if @elements
        @elements.each { |e| yield(element_class.new(@container, :object, e)) }
      else
        0.upto(@length - 1) { |i| yield iterator_object(i) }
      end

      @length
    end

    #
    # Get the element at the given index.
    # By default, this is 1-indexed to keep compatibility with Watir.
    #
    # Also note that because of Watir's lazy loading, this will return an Element
    # instance even if the index is out of bounds.
    #
    # @param [Fixnum] n Index of wanted element, 1-indexed unless Celerity.index_offset is changed.
    # @return [Celerity::Element] Returns a subclass of Celerity::Element
    #

    def [](n)
      if @elements && @elements[n - Celerity.index_offset]
        element_class.new(@container, :object, @elements[n - Celerity.index_offset])
      else
        iterator_object(n - Celerity.index_offset)
      end
    end

    #
    # Get the first element in this collection. (Celerity-specific)
    #
    # @return [Celerity::Element] Returns a subclass of Celerity::Element
    #

    def first
      self[Celerity.index_offset]
    end

    #
    # Get the last element in this collection. (Celerity-specific)
    #
    # @return [Celerity::Element] Returns a subclass of Celerity::Element
    #

    def last
      self[Celerity.index_offset - 1]
    end

    #
    # Note: This can be quite useful in irb:
    #
    #   puts browser.text_fields
    #
    # @return [String] A string representation of all elements in this collection.
    #

    def to_s
      map { |e| e.to_s }.join("\n")
    end

    private

    def iterator_object(i)
      element_class.new(@container, :index, i + Celerity.index_offset)
    end

  end # ElementCollection
end # Celerity