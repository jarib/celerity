module Celerity
  class InputElement < Element
    include ClickableElement
    include DisabledElement

    ATTRIBUTES = BASE_ATTRIBUTES | [:type, :name, :value, :checked, :disabled, :readonly, :size, :maxlength,
                                    :src, :alt, :usemap, :ismap, :tabindex, :accesskey, :onfocus, :onblur,
                                    :onselect, :onchange, :accept, :align]

    def readonly?
      assert_exists
      @object.hasAttribute 'readonly'
    end

    private

    def assert_not_readonly
      if readonly?
        raise ObjectReadOnlyException,
          "InputElement #{identifier_string} is read only."
      end
    end

  end
end