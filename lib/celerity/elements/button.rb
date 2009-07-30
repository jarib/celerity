module Celerity

  #
  # Input: Button
  #
  # Class representing button elements.
  #
  # This class covers both <button> and <input type="submit|reset|image|button" /> elements.
  #

  class Button < InputElement
    TAGS = [ Identifier.new('button'),
             Identifier.new('input', :type => %w[submit reset image button]) ]

    # Attribute list is a little weird due to this class covering both <button>
    # and <input type="submit|reset|image|button" />
    ATTRIBUTES = ATTRIBUTES | [:type, :disabled, :tabindex, :accesskey, :onfocus, :onblur] | [:src, :usemap, :ismap]
    DEFAULT_HOW = :value

    #
    # @api private
    #

    def locate
      # We want the :value attribute to point to the inner HTML for <button> elements,
      # and to the value attribute for <input type="button"> elements.

      if (val = @conditions[:value])
        button_ident      = Identifier.new('button')
        button_ident.text = val
        input_ident       = Identifier.new('input', :type => %w[submit reset image button], :value => [val])

        locator        = ElementLocator.new(@container, self.class)
        locator.idents = [button_ident, input_ident]

        conditions = @conditions.dup
        conditions.delete(:value)
        @object = locator.find_by_conditions(conditions)
      else
        super
      end
    end

  end # Button
end # Celerity