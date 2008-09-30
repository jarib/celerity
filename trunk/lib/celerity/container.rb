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
    attr_accessor :page_container


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
      @page_container = container.page_container
      container
    end

    # Used internally to update the page object.
    # @api private
    def update_page(page)
      @page_container.page = page
    end

    # @return [Celerity::Frame]
    def frame(*args)
      assert_exists
      Frame.new(self, *args)
    end

    # @return [Celerity::Frames]
    def frames
      assert_exists
      Frames.new(self)
    end

    # @return [Celerity::Table]
    def table(*args)
      assert_exists
      Table.new(self, *args)
    end

    # @return [Celerity::Tables]
    def tables
      assert_exists
      Tables.new(self)
    end

    # @return [Celerity::TableHeader]
    def thead(*args)
      assert_exists
      TableHeader.new(self, *args)
    end

    # @return [Celerity::TableHeaders]
    def theads
      assert_exists
      TableHeaders.new(self)
    end

    # @return [Celerity::TableBody]
    def tbody(*args)
      assert_exists
      TableBody.new(self, *args)
    end

    # @return [Celerity::TableBodies]
    def tbodies
      assert_exists
      TableBodies.new(self)
    end

    # @return [Celerity::TableFooter]
    def tfoot(*args)
      assert_exists
      TableFooter.new(self, *args)
    end

    # @return [Celerity::TableFooters]
    def tfoots
      assert_exists
      TableFooters.new(self)
    end
    alias_method :tfeet, :tfoots # :-)


    # @return [Celerity::TableCell]
    def cell(*args)
      assert_exists
      TableCell.new(self, *args)
    end

    # @return [Celerity::TableCells]
    def cells
      assert_exists
      TableCells.new(self)
    end

    # @return [Celerity::TableRow]
    def row(*args)
      assert_exists
      TableRow.new(self, *args)
    end

    # @return [Celerity::TableRows]
    def rows
      assert_exists
      TableRows.new(self)
    end

    # @return [Celerity::Button]
    def button(*args)
      assert_exists
      Button.new(self, *args)
    end

    # @return [Celerity::Buttons]
    def buttons
      assert_exists
      Buttons.new(self)
    end

    # @return [Celerity::FileField]
    def file_field(*args)
      assert_exists
      FileField.new(self, *args)
    end

    # @return [Celerity::FileFields]
    def file_fields
      assert_exists
      FileFields.new(self)
    end

    # @return [Celerity::TextField]
    def text_field(*args)
      assert_exists
      TextField.new(self, *args)
    end

    # @return [Celerity::TextFields]
    def text_fields
      assert_exists
      TextFields.new(self)
    end

    # @return [Celerity::Hidden]
    def hidden(*args)
      assert_exists
      Hidden.new(self, *args)
    end

    # @return [Celerity::Hiddens]
    def hiddens
      assert_exists
      Hiddens.new(self)
    end

    # @return [Celerity::SelectList]
    def select_list(*args)
      assert_exists
      SelectList.new(self, *args)
    end

    # @return [Celerity::SelectLists]
    def select_lists
      assert_exists
      SelectLists.new(self)
    end

    # @return [Celerity::Option]
    def option(*args)
      assert_exists
      Option.new(self, *args)
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
      assert_exists
      CheckBox.new(self, *args)
    end

    # @return [Celerity::CheckBoxes]
    def checkboxes
      assert_exists
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
      assert_exists
      Radio.new(self, *args)
    end

    # @return [Celerity::Radios]
    def radios
      assert_exists
      Radios.new(self)
    end

    # @return [Celerity::Link]
    def link(*args)
      assert_exists
      Link.new(self, *args)
    end

    # @return [Celerity::Links]
    def links
      assert_exists
      Links.new(self)
    end

    # @return [Celerity::Ul]
    def ul(*args)
      assert_exists
      Ul.new(self, *args)
    end

    # @return [Celerity::Uls]
    def uls
      assert_exists
      Uls.new(self)
    end

    # @return [Celerity::Ol]
    def ol(*args)
      assert_exists
      Ol.new(self, *args)
    end

    # @return [Celerity::Ols]
    def ols
      assert_exists
      Ols.new(self)
    end

    # @return [Celerity::Li]
    def li(*args)
      assert_exists
      Li.new(self, *args)
    end

    # @return [Celerity::Lis]
    def lis
      assert_exists
      Lis.new(self)
    end

    # @return [Celerity::Map]
    def map(*args)
      assert_exists
      Map.new(self, *args)
    end

    # @return [Celerity::Maps]
    def maps
      assert_exists
      Maps.new(self)
    end

    # @return [Celerity::Area]
    def area(*args)
      assert_exists
      Area.new(self, *args)
    end

    # @return [Celerity::Areas]
    def areas
      assert_exists
      Areas.new(self)
    end

    # @return [Celerity::Image]
    def image(*args)
      assert_exists
      Image.new(self, *args)
    end

    # @return [Celerity::Images]
    def images
      assert_exists
      Images.new(self)
    end

    # @return [Celerity::Div]
    def div(*args)
      assert_exists
      Div.new(self, *args)
    end

    # @return [Celerity::Divs]
    def divs
      assert_exists
      Divs.new(self)
    end

    # @return [Celerity::Form]
    def form(*args)
      assert_exists
      Form.new(self, *args)
    end

    # @return [Celerity::Forms]
    def forms
      assert_exists
      Forms.new(self)
    end

    # @return [Celerity::Span]
    def span(*args)
      assert_exists
      Span.new(self, *args)
    end

    # @return [Celerity::Spans]
    def spans
      assert_exists
      Spans.new(self)
    end

    # @return [Celerity::P]
    def p(*args)
      assert_exists
      P.new(self, *args)
    end

    # @return [Celerity::Ps]
    def ps
      assert_exists
      Ps.new(self)
    end

    # @return [Celerity::Pre]
    def pre(*args)
      assert_exists
      Pre.new(self, *args)
    end

    # @return [Celerity::Pres]
    def pres
      assert_exists
      Pres.new(self)
    end

    # @return [Celerity::Label]
    def label(*args)
      assert_exists
      Label.new(self, *args)
    end

    # @return [Celerity::Labels]
    def labels
      assert_exists
      Labels.new(self)
    end

    # @return [Celerity::H1]
    def h1(*args)
      assert_exists
      H1.new(self, *args)
    end

    # @return [Celerity::H2]
    def h2(*args)
      assert_exists
      H2.new(self, *args)
    end

    # @return [Celerity::H3]
    def h3(*args)
      assert_exists
      H3.new(self, *args)
    end

    # @return [Celerity::H4]
    def h4(*args)
      assert_exists
      H4.new(self, *args)
    end

    # @return [Celerity::H5]
    def h5(*args)
      assert_exists
      H5.new(self, *args)
    end

    # @return [Celerity::H6]
    def h6(*args)
      assert_exists
      H6.new(self, *args)
    end

    # @return [Celerity::H1s]
    def h1s
      assert_exists
      H1s.new(self)
    end

    # @return [Celerity::H2s]
    def h2s
      assert_exists
      H2s.new(self)
    end

    # @return [Celerity::H3s]
    def h3s
      assert_exists
      H3s.new(self)
    end

    # @return [Celerity::H4s]
    def h4s
      assert_exists
      H4s.new(self)
    end

    # @return [Celerity::H5s]
    def h5s
      assert_exists
      H5s.new(self)
    end

    # @return [Celerity::H6s]
    def h6s
      assert_exists
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
