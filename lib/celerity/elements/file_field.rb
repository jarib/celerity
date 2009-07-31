module Celerity

  #
  # For fields that accept file uploads
  #

  class FileField < InputElement
    TAGS = [ Identifier.new('input', :type => %w[file]) ]
    DEFAULT_HOW = :name

    #
    # Set the file field to the given path
    #

    def set(path)
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