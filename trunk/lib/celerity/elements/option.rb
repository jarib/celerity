module Celerity
  class Option < Element
    TAGS = [ Identifier.new('option')]
    ATTRIBUTES = BASE_ATTRIBUTES | [:selected, :disabled, :label, :value]

    def select
      assert_exists
      # click?
      @object.setSelected(true)
    end

    def selected?
      assert_exists
      @object.isSelected
    end
  end
end