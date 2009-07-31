module Celerity
  class Form < Element
    include Container

    TAGS = [Identifier.new('form')]

    # HTML 4.01 Transitional DTD
    ATTRIBUTES = BASE_ATTRIBUTES | [:action, :method, :enctype, :accept, :name, :onsubmit, :onreset, :target, :'accept-charset']
    DEFAULT_HOW = :name

    #
    # Submits the form.
    #
    # This method should be avoided - invoke the user interface element that triggers the submit instead.
    #

    def submit
      assert_exists
      @object.submit(nil)
    end

  end # Form
end # Celerity