module Celerity
  
  # What we essentially want is the ability to perform a fast SQLish 'select' against the DOM. 
  # Instead of iterating twice through a lot of elements, we could modify the Identifier objects to contain 
  # everything in our 'query'. Perhaps we could also move the logic for constructing these queries to either 
  # Element or its subclasses, getting rid of the Container#locate_* methods. ??
  # Jari - 2008-05-11
  class ElementLocator
    
    def initialize(object, idents)
      @object = object
      @idents = idents
    end

    def find_by_attribute(attribute, what, value = nil)
      if value
        collection.find do |e|
          matches?(e.getAttribute(attribute), what) && matches?(e.getValueAttribute, value)
        end
      else
        collection.find { |e| matches?(e.getAttributeValue(attribute), what) }
      end
    end
  
    def find_by_text(text)
      collection.find { |e| matches?(e.asText, text) }
    end
    
    def find_by_id(what)
      case what
      when Regexp
        elements_by_tag_names(@idents.map { |e| e.tag }).find { |elem| elem.getIdAttribute =~ what }
        # collection.find { |elem| elem.getIdAttribute =~ what } # seems slower
        # find_by_attribute('id', what)
      when String
        @object.getHtmlElementById(what)
      else
        raise ArgumentError, "Argument #{what.inspect} should be a String or Regexp"
      end
    end
    
    def find_by_xpath(what)
      what = ".#{what}" if what[0] == ?/
      @object.getByXPath(what).to_a.first
    end

    def [](idx)
      collection[idx - 1]
    end
    alias_method :find_by_index, :[]
    
    private 

    def collection
      @collection ||= elements_by_idents(@idents)
    end
    
    def matches?(string, what)
      Regexp === what ? string.match(what) : string == what.to_s
    end

    def elements_by_tag_names(tags)
      # HtmlUnit's getHtmlElementsByTagNames won't get elements in the correct order, making :index fail
      tags.map! { |t| t.downcase }
      @object.getAllHtmlChildElements.iterator.to_a.select do |elem|
        tags.include?(elem.getTagName)
      end
    end
    
    def elements_by_idents(idents)
      tags = idents.map { |e| e.tag }
      @object.getAllHtmlChildElements.iterator.to_a.select do |e|
        if tags.include?(e.getTagName)
          idents.any? do |ident|
            next unless ident.tag == e.getTagName
            if ident.attributes.empty?
              true
            else
              ident.attributes.any? { |key, value| value.include?(e.getAttributeValue(key.to_s)) }
            end
          end
        end
      end
    end

    # just keeping this around for speed comparisons
    def elements_by_idents_alt(idents)
      tags = idents.map { |e| e.tag }
      elements_by_tag_names(tags).select do |e|
        idents.any? do |ident|
          next unless ident.tag == e.getTagName
          if ident.attributes.empty?
            true
          else
            ident.attributes.any? { |key, value| value.include?(e.getAttributeValue(key.to_s)) }
          end
        end
      end
    end

  end # ElementLocator
end # Celerity
