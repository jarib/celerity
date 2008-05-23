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
    
    def body(*args)
      assert_exists
      TableBody.new(self, *args)
    end
    def bodies
      assert_exists
      TableBodies.new(self)
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
    
    def option(*args)
      assert_exists
      Option.new(self, *args)
    end

    def check_box(*args)
      assert_exists
      CheckBox.new(self, *args)
    end
    alias_method :checkbox, :check_box
    alias_method :checkBox, :check_box
    # TODO: Move to watir_compatibility? 2008-05-23 Alexander

    def checkboxes
      assert_exists
      CheckBoxes.new(self)
    end

    def radio(*args)
      assert_exists
      Radio.new(self, *args)
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

    private

    def matches?(string, what)
      Regexp === what ? string.match(what) : string == what.to_s
    end
    
  end # Container
end # Celerity
