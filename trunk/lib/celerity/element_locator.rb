module Celerity
  
  # What we essentially want is the ability to perform a fast SQLish 'select' against the DOM. 
  # Instead of iterating twice through a lot of elements, we could modify the Identifier objects to contain 
  # everything in our 'query'. 
  # Jari - 2008-05-11
  class ElementLocator
    
    def initialize(object, element)
      @object = object
      @element = element
      @idents = element.class::TAGS
      @tags = @idents.map { |e| e.tag.downcase }
    end

    def locate(how, what, value = nil)
      begin
        case how
        when :id
          find_by_id(what)
        when :xpath
          find_by_xpath(what)
        when :name, :value, :title, :caption, :class
          find_by_attribute(how.to_s, what, value)
        when :text
          find_by_text(what)
        when :index
          find_by_index(what.to_i)
        when :url # shouldn't we also have :href here?
          find_by_attribute('href', what) if [Celerity::Link, Celerity::Map, Celerity::Area].include?(@element.class)
        when :src, :alt
          find_by_attribute(how.to_s, what) if Celerity::Image === @element
        when :action, :method
          find_by_attribute(how.to_s, what) if Celerity::Form === @element
        else
          raise MissingWayOfFindingObjectException, "No how #{how.inspect}"
        end
      rescue HtmlUnit::ElementNotFoundException
      end
    end

    def find_by_conditions(conditions)
      raise NotImplementedError
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
        elements_by_tag_names.find { |elem| elem.getIdAttribute =~ what }
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
    
    def collection
      @collection ||= elements_by_idents
    end

    private 

    def elements_by_idents
      @object.getAllHtmlChildElements.iterator.to_a.select do |e|
        if @tags.include?(e.getTagName)
          @idents.any? do |ident|
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
    # def elements_by_idents_alt(idents)
    #   tags = idents.map { |e| e.tag }
    #   elements_by_tag_names(tags).select do |e|
    #     idents.any? do |ident|
    #       next unless ident.tag == e.getTagName
    #       if ident.attributes.empty?
    #         true
    #       else
    #         ident.attributes.any? { |key, value| value.include?(e.getAttributeValue(key.to_s)) }
    #       end
    #     end
    #   end
    # end

    # this could be optimized when iterating - we don't need to check the class of 'what' for each element
    def matches?(string, what)
      Regexp === what ? string.match(what) : string == what.to_s
    end

    def elements_by_tag_names
      # HtmlUnit's getHtmlElementsByTagNames won't get elements in the correct order, making :index fail
      @object.getAllHtmlChildElements.iterator.to_a.select do |elem|
        @tags.include?(elem.getTagName)
      end
    end


  end # ElementLocator
end # Celerity
