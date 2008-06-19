module Celerity
  class Frame < Element
    include Container
    attr_accessor :page
    
    TAGS = [Identifier.new('frame'), Identifier.new('iframe')]
    ATTRIBUTES = BASE_ATTRIBUTES | [:longdesc, :name, :src, :frameborder, :marginwidth, :marginheight, :noresize, :scrolling]
    DEFAULT_HOW = :name
    
    def locate
      super
      if @object
        @inline_frame_object = @object.getEnclosedWindow.getFrameElement
        if (frame = @object.getEnclosedPage.getDocumentElement)
          @object = frame
        end
      end
    end
    
    def assert_exists
      locate unless @object
      unless @object
        raise UnknownFrameException, "unable to locate frame, using #{identifier_string}"
      end
    end
    
    def update_page(value)
      @page_container.page = value.getEnclosingWindow.getTopWindow.getEnclosedPage
    end

    def to_s
      assert_exists
      create_string(@inline_frame_object)
    end
    
    def method_missing(meth, *args, &blk)
      meth = method_to_attribute(meth)
      if self.class::ATTRIBUTES.include?(meth)
        assert_exists
        @inline_frame_object.getAttributeValue(meth.to_s)
      else
        Log.warn "Element\#method_missing calling super with #{meth.inspect}"
        super
      end
    end
    
  end

end