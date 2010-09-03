module Celerity

  #
  # For fields that accept file uploads
  #

  class FileField < InputElement
    TAGS = [ Identifier.new('input', :type => %w[file]) ]


    #
    # Same as value=, but also verifies that the file exists.
    #

    def set(path)
      raise Errno::ENOENT, path unless File.exist?(path.to_s)
      self.value = path
    end

    #
    # Set the file field to the given path
    #

    def value=(path)
      assert_exists
      path = path.to_s

      @object.setValueAttribute path

      unless @object.getContentType
        @object.setContentType(Celerity::Util.content_type_for(path))
      end

      path
    end

  end # FileField
end # Celerity
