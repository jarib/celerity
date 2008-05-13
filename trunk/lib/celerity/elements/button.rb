module Celerity
  # 
  # Input: Button
  #
  # Class representing button elements
  #
  class Button < InputElement
    TAGS = [ Identifier.new('button'), 
             Identifier.new('input', :type => %w(submit reset image button)) ]
    DEFAULT_HOW = :value

    def locate
      # ugly..
      if (val = @conditions.delete(:value))
        locator = ElementLocator.new(@container.object, self.class)
        button_ident = Identifier.new('button')
        button_ident.text = val
        input_ident = Identifier.new('input', :type => %w(submit reset image button), :value => [val])
        locator.idents = [button_ident, input_ident]
        @object = locator.find_by_conditions(@conditions)
      else
        super
      end
    end
    
  end
  
end