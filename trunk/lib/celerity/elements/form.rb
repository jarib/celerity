module Celerity
  class Form < Element
    include Container
    TAGS = [Identifier.new('form')]
    # HTML 4.01 Transitional DTD
    ATTRIBUTES = BASE_ATTRIBUTES | [:action, :method, :enctype, :accept, :name, :onsubmit, :onreset, :target, :'accept-charset']
    DEFAULT_HOW = :name
  
    def submit
      assert_exists
      raise NotImplementedError      
      # waiting for HtmlUnit fix?
    end

  end  
end