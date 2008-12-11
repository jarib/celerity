module Celerity

  # This class contains methods for accessing elements inside a container,
  # usually the Browser object, meaning the current page.
  # The most common syntax is
  #   browser.elem(:attribute, 'value')
  #
  # Note that the element is located lazily, so no exceptions will be raised
  # if the element doesn't exist until you call a method on the resulting object.
  # To do this you would normally use Element#exists? or an action method,
  # like ClickableElement#click.
  # You can also pass in a hash:
  #
  #   browser.link(:index => 1).click
  #
  # All elements support multiple attributes identification using the
  # hash syntax (though this might not always be compatible with Watir):
  #
  #   browser.span(:class_name => 'product', :index => 5).text
  #
  # Checkboxes and radio buttons support a special three-argument syntax:
  #
  #   browser.check_box(:name, 'a_name', '1234').set
  #
  # You can also get all the elements of a certain type by using the plural form (@see Celerity::ElementCollections):
  #
  #   browser.links # => #<Celerity::Links:0x7a1c2da2 ...>
  #
  module Container
    include Celerity::Exception
    
    # Points back to the Browser instance that contains this element
    attr_accessor :browser


    # Check if the element contains the given text.
    #
    # @param  [String, Regexp] expected_text The text to look for.
    # @return [Fixnum, nil]  The index of the matched text, or nil if it doesn't match.
    def contains_text(expected_text)
      assert_exists
      return nil unless respond_to? :text

      case expected_text
      when Regexp
        text() =~ expected_text
      when String
        text().index(expected_text)
      else
        raise TypeError, "expected String or Regexp, got #{expected_text.inspect}:#{expected_text.class}"
      end
    end

    # Used internally to update the container object.
    # @api private
    def container=(container)
      @container = container
      @browser = container.browser
      container
    end

    # Used internally to update the page object.
    # @api private
    def update_page(page)
      @browser.page = page
    end

    # @return [Celerity::Frame]
    def frame(*args)
      Frame.new(self, *args)
    end

    # @return [Celerity::Frames]
    def frames
      Frames.new(self)
    end

    # @return [Celerity::Table]
    def table(*args)
      Table.new(self, *args)
    end

    # @return [Celerity::Tables]
    def tables
      Tables.new(self)
    end

    # @return [Celerity::TableHeader]
    def thead(*args)
      TableHeader.new(self, *args)
    end

    # @return [Celerity::TableHeaders]
    def theads
      TableHeaders.new(self)
    end

    # @return [Celerity::TableBody]
    def tbody(*args)
      TableBody.new(self, *args)
    end

    # @return [Celerity::TableBodies]
    def tbodies
      TableBodies.new(self)
    end

    # @return [Celerity::TableFooter]
    def tfoot(*args)
      TableFooter.new(self, *args)
    end

    # @return [Celerity::TableFooters]
    def tfoots
      TableFooters.new(self)
    end
    alias_method :tfeet, :tfoots # :-)

    # @return [Celerity::TableCell]
    def cell(*args)
      TableCell.new(self, *args)
    end

    # @return [Celerity::TableCells]
    def cells
      TableCells.new(self)
    end
    
    # Watir's cells() won't return <th> elements. 
    # This is a workaround.
    #
    # @return [Celerity::Th]
    def th(*args)
      Th.new(self, *args)
    end
    
    # TODO: implement or change api, 
    # @see th
    def ths
      raise NotImplementedError
    end

    # @return [Celerity::TableRow]
    def row(*args)
      TableRow.new(self, *args)
    end

    # @return [Celerity::TableRows]
    def rows
      TableRows.new(self)
    end

    # @return [Celerity::Button]
    def button(*args)
      Button.new(self, *args)
    end

    # @return [Celerity::Buttons]
    def buttons
      Buttons.new(self)
    end

    # @return [Celerity::FileField]
    def file_field(*args)
      FileField.new(self, *args)
    end

    # @return [Celerity::FileFields]
    def file_fields
      FileFields.new(self)
    end

    # @return [Celerity::TextField]
    def text_field(*args)
      TextField.new(self, *args)
    end

    # @return [Celerity::TextFields]
    def text_fields
      TextFields.new(self)
    end

    # @return [Celerity::Hidden]
    def hidden(*args)
      Hidden.new(self, *args)
    end

    # @return [Celerity::Hiddens]
    def hiddens
      Hiddens.new(self)
    end

    # @return [Celerity::SelectList]
    def select_list(*args)
      SelectList.new(self, *args)
    end

    # @return [Celerity::SelectLists]
    def select_lists
      SelectLists.new(self)
    end

    # Since finding checkboxes by value is very common, you can use this shorthand:
    #
    #   browser.check_box(:name, 'a_name', '1234').set
    #
    # or
    #
    #   browser.check_box(:name => 'a_name', :value => '1234').set
    #
    # @return [Celerity::CheckBox]
    def check_box(*args)
      CheckBox.new(self, *args)
    end

    # @return [Celerity::CheckBoxes]
    def checkboxes
      CheckBoxes.new(self)
    end

    # Since finding radios by value is very common, you can use this shorthand:
    #
    #   browser.radio(:name, 'a_name', '1234').set
    #
    # or
    #
    #   browser.radio(:name => 'a_name', :value => '1234').set
    #
    # @return [Celerity::Radio]
    def radio(*args)
      Radio.new(self, *args)
    end

    # @return [Celerity::Radios]
    def radios
      Radios.new(self)
    end

    # @return [Celerity::Link]
    def link(*args)
      Link.new(self, *args)
    end

    # @return [Celerity::Links]
    def links
      Links.new(self)
    end

    # @return [Celerity::Ul]
    def ul(*args)
      Ul.new(self, *args)
    end

    # @return [Celerity::Uls]
    def uls
      Uls.new(self)
    end

    # @return [Celerity::Ol]
    def ol(*args)
      Ol.new(self, *args)
    end

    # @return [Celerity::Ols]
    def ols
      Ols.new(self)
    end
    
    def dl(*args)
      Dl.new(self, *args)
    end
    
    def dls
      Dls.new(self, *args)
    end

    def dt(*args)
      Dt.new(self, *args)
    end
    
    def dts
      Dts.new(self, *args)
    end

    def dd(*args)
      Dd.new(self, *args)
    end
    
    def dds
      Dds.new(self, *args)
    end

    # @return [Celerity::Li]
    def li(*args)
      Li.new(self, *args)
    end

    # @return [Celerity::Lis]
    def lis
      Lis.new(self)
    end

    # @return [Celerity::Map]
    def map(*args)
      Map.new(self, *args)
    end

    # @return [Celerity::Maps]
    def maps
      Maps.new(self)
    end

    # @return [Celerity::Area]
    def area(*args)
      Area.new(self, *args)
    end

    # @return [Celerity::Areas]
    def areas
      Areas.new(self)
    end

    # @return [Celerity::Image]
    def image(*args)
      Image.new(self, *args)
    end

    # @return [Celerity::Images]
    def images
      Images.new(self)
    end

    # @return [Celerity::Div]
    def div(*args)
      Div.new(self, *args)
    end

    # @return [Celerity::Divs]
    def divs
      Divs.new(self)
    end

    # @return [Celerity::Form]
    def form(*args)
      Form.new(self, *args)
    end

    # @return [Celerity::Forms]
    def forms
      Forms.new(self)
    end
    
    # @return [Celerity::Option]
    def option(*args)
      Option.new(self, *args)
    end

    # @return [Celerity::Span]
    def span(*args)
      Span.new(self, *args)
    end

    # @return [Celerity::Spans]
    def spans
      Spans.new(self)
    end

    # @return [Celerity::P]
    def p(*args)
      P.new(self, *args)
    end

    # @return [Celerity::Ps]
    def ps
      Ps.new(self)
    end

    # @return [Celerity::Pre]
    def pre(*args)
      Pre.new(self, *args)
    end

    # @return [Celerity::Pres]
    def pres
      Pres.new(self)
    end

    # @return [Celerity::Label]
    def label(*args)
      Label.new(self, *args)
    end

    # @return [Celerity::Labels]
    def labels
      Labels.new(self)
    end
    
    def meta(*args)
      Meta.new(self, *args)
    end
    
    def metas(*args)
      Metas.new(self, *args)
    end

    # @return [Celerity::H1]
    def h1(*args)
      H1.new(self, *args)
    end

    # @return [Celerity::H2]
    def h2(*args)
      H2.new(self, *args)
    end

    # @return [Celerity::H3]
    def h3(*args)
      H3.new(self, *args)
    end

    # @return [Celerity::H4]
    def h4(*args)
      H4.new(self, *args)
    end

    # @return [Celerity::H5]
    def h5(*args)
      H5.new(self, *args)
    end

    # @return [Celerity::H6]
    def h6(*args)
      H6.new(self, *args)
    end

    # @return [Celerity::H1s]
    def h1s
      H1s.new(self)
    end

    # @return [Celerity::H2s]
    def h2s
      H2s.new(self)
    end

    # @return [Celerity::H3s]
    def h3s
      H3s.new(self)
    end

    # @return [Celerity::H4s]
    def h4s
      H4s.new(self)
    end

    # @return [Celerity::H5s]
    def h5s
      H5s.new(self)
    end

    # @return [Celerity::H6s]
    def h6s
      H6s.new(self)
    end

    # Used internally.
    #
    # @param [String] string The string to match against.
    # @param [Regexp, String, #to_s] what The match we're looking for.
    # @return [MatchData, true, false, nil]
    #
    # @api private
    def matches?(string, what)
      Regexp === what ? string =~ what : string == what.to_s
    end

  end # Container
end # Celerity
