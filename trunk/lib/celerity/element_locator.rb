module Celerity
  class ElementLocator

    def initialize(collection)
      @collection = collection
    end
    
    def find_by_attribute(attribute, what, value = nil)
      if value
        @collection.find do |e|
          matches?(e.getAttribute(attribute), what) && matches?(e.getValueAttribute, value))
        end
      else
        @collection.find { |e| matches?(e.getAttributeValue(attribute), what) }
      end
    end
  
    def find_by_text(text)
      @collection.find { |e| matches?(e.asText, text) }
    end
    
    def [](idx)
      @collection[idx - 1]
    end
    alias_method :find_by_index, :[]
    
    private 
    
    # this could be optimized when iterating - we don't need to check the class of 'what' for each element
    # perhaps something like this
    # find_matching_element(collection, method = :to_s, what)
    def matches?(string, what)
      Regexp === what ? string.match(what) : string == what.to_s
    end
  
  end
end