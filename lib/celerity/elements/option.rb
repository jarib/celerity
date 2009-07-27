module Celerity

  #
  # Represents an option in a select list.
  #

  class Option < Element
    include ClickableElement
    include DisabledElement

    TAGS = [ Identifier.new('option') ]
    ATTRIBUTES = BASE_ATTRIBUTES | [:selected, :disabled, :label, :value]
    DEFAULT_HOW = :text

    alias_method :select, :click

    #
    # Is this option selected?
    #

    def selected?
      assert_exists
      @object.isSelected
    end

    def label
      # overrides Container#label
      assert_exists
      @object.getLabelAttribute
    end
  end
end