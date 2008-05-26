module Celerity
  # For fields that accept file uploads
  class FileField < InputElement
    TAGS = [ Identifier.new('input', :type => %w(file)) ]
    DEFAULT_HOW = :name
  
    def set(value)
      assert_exists
      @object.setValueAttribute(value.to_s)
    end
  end
end