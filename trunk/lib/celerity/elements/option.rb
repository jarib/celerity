module Celerity
  class Option < Element
    include ClickableElement
    include DisabledElement
    
    TAGS = [ Identifier.new('option')]
    ATTRIBUTES = BASE_ATTRIBUTES | [:selected, :disabled, :label, :value]

    alias_method :select, :click

    def selected?
      assert_exists
      @object.isSelected
    end
  end
end