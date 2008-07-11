module Celerity
  # For fields that accept file uploads
  class FileField < InputElement
    TAGS = [ Identifier.new('input', :type => %w(file)) ]
    DEFAULT_HOW = :name
  
    # Set the file field to the given path
    def set(path)
      assert_exists
      @object.setValueAttribute(path.to_s)
    end
  end
end