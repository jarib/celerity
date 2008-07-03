module Celerity
  
  # What we essentially want is the ability to perform a fast SQLish 'select' against the DOM. 
  # Instead of iterating twice through a lot of elements, we could modify the Identifier objects to contain 
  # everything in our 'query'. 
  # Jari - 2008-05-11
  class ElementLocator
    include Celerity::Exception
    attr_accessor :idents
    
    
    def initialize(object, element_class)
      @object = object
      @element_class = element_class
      @attributes = @element_class::ATTRIBUTES # could check for 'strict' here?
      @idents = @element_class::TAGS
      @tags = @idents.map { |e| e.tag.downcase }
    end

    def find_by_conditions(conditions)
      @condition_idents = []
      attributes = Hash.new { |h, k| h[k] = [] }
      index = 0 # by default, return the first matching element
      text = nil 
      
      conditions.each do |how, what|
        case how
        when :object
          return what
        when :id
          return find_by_id(what)
        when :xpath
          return find_by_xpath(what)
        when :class_name
          how = :class
        when :url
          how = :href
        when :caption
          how = :text
        end
      
        if @attributes.include?(how)
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
        merged = attributes.merge(ident.attributes) do |key, v1, v2|
          v1 | v2
        end
          
        id = Identifier.new(ident.tag, merged)
        # «original» identifier takes precedence for :text
        id.text = ident.text || text
        @condition_idents << id
      end
      
      if index == 0
        element_by_idents(@condition_idents)
      else
        elements_by_idents(@condition_idents)[index]
      end

    rescue HtmlUnit::ElementNotFoundException
      nil # for rcov
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
