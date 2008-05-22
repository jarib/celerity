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
      @page_container.set_page(value.getEnclosingWindow.getTopWindow.getEnclosedPage)
    end

    def to_s
      assert_exists
      create_string(@inline_frame_object)
    end
    
  end

end