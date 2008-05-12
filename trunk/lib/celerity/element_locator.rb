module Celerity
  
  # What we essentially want is the ability to perform a fast SQLish 'select' against the DOM. 
  # Instead of iterating twice through a lot of elements, we could modify the Identifier objects to contain 
  # everything in our 'query'. 
  # Jari - 2008-05-11
  class ElementLocator
    
    def initialize(object, element_class)
      @object = object
      @element_class = element_class
      @idents = @element_class::TAGS
      @tags = @idents.map { |e| e.tag.downcase }
    end

    def find_by_conditions(conditions)
      @identifiers = []
      attributes = Hash.new { |h, k| h[k] = [] }
      index = 0 # by default, return the first matching element
      text = nil 
      
      begin 
        conditions.each do |how, what|
          how = :class if how == :class_name
          how = :href  if how == :url
          how = :text  if how == :caption
        
          if how == :id
            return find_by_id(what)
          elsif how == :xpath
            return find_by_xpath(what)
          elsif @element_class::ATTRIBUTES.include?(how)
            attributes[how] << what  
          elsif how == :index
            index = what.to_i - 1
          elsif how == :text
            text = what
          else
            raise MissingWayOfFindingObjectException, "No how #{how.inspect}"
          end

        end

        @idents.each do |ident|
          id = Identifier.new(ident.tag, attributes.merge(ident.attributes))
          id.text = text if text
          @identifiers << id
        end
        
        if index == 0
          element_by_idents(@identifiers)
        else
          elements_by_idents(@identifiers)[index]
        end

      rescue HtmlUnit::ElementNotFoundException
        nil # for rcov
      end
    end
    
    def find_by_id(what)
      case what
      when Regexp
        elements_by_tag_names.find { |elem| elem.getIdAttribute =~ what }
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

    def elements_by_idents(idents = nil)
      get_by_idents(:select, idents || @idents)
    end
    
    def element_by_idents(idents = nil)
      get_by_idents(:find, idents || @idents)
    end

    private 

    def get_by_idents(meth, idents)
      @object.getAllHtmlChildElements.iterator.to_a.send(meth) do |e|
        if @tags.include?(e.getTagName)
          idents.any? do |ident|
            next unless ident.tag == e.getTagName
            attr_result = ident.attributes.all? do |key, value| 
              value.any? { |val| matches?(e.getAttributeValue(key.to_s), val) } 
            end 
            
            if ident.text
              attr_result && matches?(e.asText, ident.text) 
            else
              attr_result
            end
            
          end
        end
      end
    end

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
