module Celerity
  module Container
    include Celerity::Exception
    attr_accessor :page_container

    def set_container(container)
      @container = container
      @page_container = container.page_container
    end
    
    def update_page(page)
      @page_container.set_page(page)
    end
    
    def contains_text(expected_text)
      assert_exists
      case expected_text
      when Regexp
        text().match(expected_text)
      when String
        text().index(expected_text)
      else
        raise ArgumentError, "Argument #{expected_text.inspect} should be a String or Regexp."
      end
    end

    def frame(*args)
      assert_exists
      Frame.new(self, *args)
    end

    def table(*args)
      assert_exists
      Table.new(self, *args)
    end 
    def tables
      assert_exists
      Tables.new(self)
    end
    
    def cell(*args)
      assert_exists      
      TableCell.new(self, *args)
    end
    def cells
      assert_exists
      TableCells.new(self)
    end
    
    def row(*args)
      assert_exists
      TableRow.new(self, *args)
    end
    def rows
      assert_exists
      TableRows.new(self)
    end
  
    def button(*args)
      assert_exists
      Button.new(self, *args)
    end
    def buttons
      assert_exists
      Buttons.new(self)
    end

    def file_field(*args)
      assert_exists
      FileField.new(self, *args)
    end
    def file_fields
      assert_exists
      FileFields.new(self)
    end
    
    def text_field(*args)
      assert_exists
      TextField.new(self, *args)
    end
    def text_fields
      assert_exists
      TextFields.new(self)
    end
    
    def hidden(*args)
      assert_exists
      Hidden.new(self, *args)
    end
    def hiddens
      assert_exists
      Hiddens.new(self)
    end
    
    def select_list(*args)
      assert_exists
      SelectList.new(self, *args)
    end
    def select_lists
      assert_exists
      SelectLists.new(self)
    end
    
    def check_box(how, what, value = nil)
      assert_exists
      CheckBox.new(self, how, what, value)
    end
    alias_method :checkbox, :check_box
    alias_method :checkBox, :check_box
    
    def checkboxes
      assert_exists
      CheckBoxes.new(self)
    end
    
    def radio(how, what, value = nil)
      assert_exists
      Radio.new(self, how, what, value)
    end
    def radios
      assert_exists
      Radios.new(self)
    end
    
    def link(*args)
      assert_exists
      Link.new(self, *args)
    end

    def links
      assert_exists
      Links.new(self)
    end

    def li(*args)
      assert_exists
      Li.new(self, *args)
    end
    def lis
      assert_exists
      Lis.new(self)
    end
    
    def map(*args)
      assert_exists
      Map.new(self, *args)
    end
    def maps
      assert_exists
      Maps.new(self)
    end
    
    def area(*args)
      assert_exists
      Area.new(self, *args)
    end
    def areas
      assert_exists
      Areas.new(self)
    end
    
    def image(*args)
      assert_exists
      Image.new(self, *args)
    end
    def images
      assert_exists
      Images.new(self)
    end
    
    #TODO: Popup method here?
    
    def div(*args)
      assert_exists
      Div.new(self, *args)
    end

    def divs
      assert_exists
      Divs.new(self)
    end

    def form(*args)
      assert_exists
      Form.new(self, *args)
    end
    def forms
      assert_exists
      Forms.new(self)
    end

    def span(*args)
      assert_exists
      Span.new(self, *args)
    end
    def spans
      assert_exists
      Spans.new(self)
    end

    def p(*args)
      assert_exists
      P.new(self, *args)
    end
    def ps
      assert_exists
      Ps.new(self)
    end

    def pre(*args)
      assert_exists
      Pre.new(self, *args)
    end
    def pres
      assert_exists
      Pres.new(self)
    end
    
    def label(*args)
      assert_exists
      Label.new(self, *args)
    end
    def labels
      assert_exists
      Labels.new(self)
    end

    protected

    def locate_input_element(element_instance, how, what, value = nil)
      idents = element_instance.class::TAGS
      tags = idents.map { |e| e.tag }
      begin
        case how
        when :id
          locate_by_id(tags, what)
        when :name, :value, :caption, :class
          locator = ElementLocator.new( elements_by_idents(idents) )
          locator.find_by_attribute(how.to_s, what, value)
        when :text
          locator = ElementLocator.new( elements_by_idents(idents) )
          locator.find_by_text(what)
        when :index
          locator = ElementLocator.new( elements_by_idents(idents) )
          locator.find_by_index(what.to_i)
        when :xpath
          locate_by_xpath(what)
        else
          raise MissingWayOfFindingObjectException
        end
      rescue HtmlUnit::ElementNotFoundException
      end
    end
    
    def locate_tagged_element(element_instance, how, what)
      tags = element_instance.class::TAGS

      begin
        case how
        when :id
          locate_by_id(tags, what)
        when :xpath
          locate_by_xpath(what)
        when :name, :value, :title, :class
          locator = ElementLocator.new( elements_by_tag_names(tags) )
          # if element_instance
          locator.find_by_attribute(how.to_s, what)
        when :text
          locator = ElementLocator.new( elements_by_tag_names(tags) )
          locator.find_by_text(what)
        when :index
          locator = ElementLocator.new( elements_by_tag_names(tags) )
          locator.find_by_index(what.to_i)
        when :url
          if [Celerity::Link, Celerity::Map, Celerity::Area].include?(element_instance.class)
            locator = ElementLocator.new( elements_by_tag_names(tags) )
            locator.find_by_attribute('href', what)
          end
        when :src, :alt
          if Celerity::Image === element_instance
            locator = ElementLocator.new( elements_by_tag_names(tags) )
            locator.find_by_attribute(how.to_s, what)
          end
        when :action, :method
          if Celerity::Form === element_instance
            locator = ElementLocator.new( elements_by_tag_names(tags) )
            locator.find_by_attribute(how.to_s, what)
          end
        else
          raise MissingWayOfFindingObjectException, "No how #{how.inspect}"
        end
      rescue HtmlUnit::ElementNotFoundException
      end
    end
    
    private 
    
    def locate_by_xpath(what)
      what = ".#{what}" if what[0] == ?/
      @object.getByXPath(what).to_a.first
    end
    
    def locate_by_id(tags, what)
      case what
      when Regexp
        elements_by_tag_names(tags).find { |elem| elem.getIdAttribute =~ what }
      when String
        @object.getHtmlElementById(what)
      else
        raise ArgumentError, "Argument #{what.inspect} should be a String or Regexp"
      end
    end

    # this could be optimized when iterating - we don't need to check the class of 'what' for each element
    # perhaps something like this
    # find_matching_element(collection, method = :to_s, what)
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
      elements = elements_by_tag_names(idents.map { |i| i.tag })
      elements.select do |e| 
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
 
            
  end # Container
end # Celerity
