module Celerity

  class Image < Element
    include ClickableElement

    TAGS = [ Identifier.new('img') ]

    ATTRIBUTES = BASE_ATTRIBUTES | [
                                      :align,
                                      :alt,
                                      :border,
                                      :height,
                                      :hspace,
                                      :ismap,
                                      :longdesc,
                                      :name,
                                      :src,
                                      :usemap,
                                      :vspace,
                                      :width,
                                    ]
    DEFAULT_HOW = :src

    #
    # returns the file created date of the image
    #

    def file_created_date
      assert_exists
      web_response = @object.getWebResponse(true)
      Time.parse(web_response.getResponseHeaderValue("Last-Modified").to_s)
    end

    #
    # returns the file size of the image in bytes
    #

    def file_size
      assert_exists
      web_response = @object.getWebResponse(true)
      web_response.getContentAsString.bytesize
    end

    #
    # returns the width in pixels of the image, as a string
    #

    def width
      assert_exists
      @object.getWidth
    end

    #
    # returns the height in pixels of the image, as a string
    #

    def height
      assert_exists
      @object.getHeight
    end

    #
    # returns true if the image is loaded
    #

    def loaded?
      assert_exists
      begin
        @object.getImageReader
        true
      rescue
        false
      end
    end

    #
    # Saves the image to the given file
    #

    def save(filename)
      assert_exists
      image_reader = @object.getImageReader
      file = java.io.File.new(filename)
      buffered_image = image_reader.read(0);
      javax.imageio.ImageIO.write(buffered_image, image_reader.getFormatName(), file);
    end

  end # Image
end # Celerity