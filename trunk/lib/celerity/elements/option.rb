module Celerity
  # Represents a select list option.
  class Option < Element
    include ClickableElement
    include DisabledElement

    TAGS = [ Identifier.new('option')]
    ATTRIBUTES = BASE_ATTRIBUTES | [:selected, :disabled, :label, :value]
    DEFAULT_HOW = :text

    alias_method :select, :click

    def selected?
      assert_exists
      @object.isSelected
    end
  end
end