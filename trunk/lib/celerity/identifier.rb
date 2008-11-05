module Celerity

  Identifier = Struct.new(:tag, :attributes) do
    attr_accessor :text

    def initialize(t, a={})
      super(t, a)
    end
  end

end
