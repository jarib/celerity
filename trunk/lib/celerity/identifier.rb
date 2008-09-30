module Celerity

  class Identifier < Struct.new(:tag, :attributes)
    attr_accessor :text

    def initialize(t, a={})
      super(t, a)
    end
  end
end
