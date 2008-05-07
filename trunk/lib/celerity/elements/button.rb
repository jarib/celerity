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
  end
  
end