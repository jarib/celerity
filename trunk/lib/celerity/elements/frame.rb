module Celerity
  class Frame < Element
    include Container
    attr_accessor :page
    
    TAGS = [Identifier.new('frame'), Identifier.new('iframe')]
    
    ATTRIBUTES = BASE_ATTRIBUTES | [:longdesc, :name, :src, :frameborder, :marginwidth, :marginheight, :noresize, :scrolling]
    DEFAULT_HOW = :name
    
    def locate
      frame_elements = @container.object.getByXPath(".//iframe | .//frame").collect { |frame| frame.getEnclosedWindow.getFrameElement }
      unless frame_elements.empty?
        case @how
        when :id, :name, :src, :class
          matching_frame_elements = frame_elements.select { |frame_element| matches?(frame_element.getAttribute(@how.to_s), @what) }
          if @frame_element = matching_frame_elements.first
            @object = @frame_element.getEnclosedPage.getDocumentElement  
          end
        when :index
          if @frame_element = frame_elements[@what-1]
            @object = @frame_element.getEnclosedPage.getDocumentElement
          end
        when :xpath
          raise NotImplementedError
        else
          raise MissingWayOfFindingObjectException
        end
      end
      raise UnknownFrameException unless @object
    end
    
    def update_page(value)
      # Log.debug(value.asXml) 
      @page_container.set_page(value.getEnclosingWindow.getTopWindow.getEnclosedPage)
    end

    def to_s
      assert_exists
      create_string(@frame_element)
    end
    
  end

end