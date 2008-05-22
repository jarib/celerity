module Celerity
  # 
  # Input: Button
  #
  # Class representing button elements
  #
  class Button < InputElement
    TAGS = [ Identifier.new('button'), 
             Identifier.new('input', :type => %w(submit reset image button)) ]
    # A little wierd attribute list due to button being both <button> and <input type="submit|reset|image|button" />
    ATTRIBUTES = BASE_ATTRIBUTES | [:type, :disabled, :tabindex, :accesskey, :onfocus, :onblur] | [:src, :usemap, :ismap]
    DEFAULT_HOW = :value

    def locate
      # ugly..
      if (val = @conditions[:value])
        locator = ElementLocator.new(@container.object, self.class)
        button_ident = Identifier.new('button')
        button_ident.text = val
        input_ident = Identifier.new('input', :type => %w(submit reset image button), :value => [val])
        locator.idents = [button_ident, input_ident]
        conditions = @conditions.dup
        conditions.delete(:value)
        @object = locator.find_by_conditions(conditions)
      else
        super
      end
    end
    
  end
  
end