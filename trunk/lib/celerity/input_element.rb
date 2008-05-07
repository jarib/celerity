module Celerity
  class InputElement < Element
    include ClickableElement
    include DisabledElement

    ATTRIBUTES = BASE_ATTRIBUTES | [:type, :name, :value, :checked, :disabled, :readonly, :size, :maxlength, 
                                    :src, :alt, :usemap, :ismap, :tabindex, :accesskey, :onfocus, :onblur, 
                                    :onselect, :onchange, :accept, :align]    
    
    def locate
      @object = @container.locate_input_element(self, @how, @what)
    end

    def readonly?
      assert_exists
      @object.isAttributeDefined('readonly')
    end

    private

    def assert_not_readonly
      if readonly?
        raise ObjectReadOnlyException,
          "Textfield #{@how.inspect} and #{@what.inspect} is read only."
      end
    end

  end
end