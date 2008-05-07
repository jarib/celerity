module Celerity
  
  # This class is the means of accessing an image on a page.
  # Normally a user would not need to create this object as it is returned by the Watir::Container#image method
  #
  # many of the methods available to this object are inherited from the Element class
  #
  class Image < Element
    include ClickableElement
    include DisabledElement
    
    TAGS = ['img']
    ATTRIBUTES = BASE_ATTRIBUTES | [:src, :alt, :longdesc, :name, :height, :width, :usemap, :ismap, :align, :border, :hspace, :vspace]
    
    # this method returns the file created date of the image
    def file_created_date
      assert_exists
      web_response = @object.getWebResponse(true)      
      return Time.parse(web_response.getResponseHeaderValue("Last-Modified").to_s)    
    end
    alias_method :fileCreatedDate, :file_created_date
    
    # this method returns the filesize of the image
    def file_size
      assert_exists
      web_response = @object.getWebResponse(true)      
      return web_response.getResponseBody().length  
    end
    alias_method :fileSize, :file_size
    
    # returns the width in pixels of the image, as a string
    def width
      assert_exists
      @object.getWidth
    end
    
    # returns the height in pixels of the image, as a string
    def height
      assert_exists
      @object.getHeight
    end
    
    def disabled?
      assert_exists
      raise NotImplementedError
    end
    alias_method :disabled, :disabled?
    
    def loaded?
      assert_exists
      begin 
        @object.getImageReader
        return true
      rescue
        return false
      end
    end
    alias_method :hasLoaded?, :loaded?
    alias_method :has_loaded?, :loaded?
    
    def save(filename)
      assert_exists
      image_reader = @object.getImageReader
      file = java.io.File.new(filename)
      buffered_image = image_reader.read(0);
      return javax.imageio.ImageIO.write(buffered_image, image_reader.getFormatName(), file);
    end
  end

end