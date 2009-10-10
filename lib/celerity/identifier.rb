module Celerity

  class Identifier
    attr_accessor :text
    attr_reader :tag, :attributes

    def initialize(tag, attributes = {})
      @tag        = tag
      @attributes = attributes
      @text       = nil
    end

    def match?(element)
      return false unless @tag == element.getTagName

      attr_result = @attributes.all? do |key, values|
        values.any? { |val| Util.matches?(element.getAttribute(key.to_s), val) }
      end

      if @text
        attr_result && Util.matches?(element.asText.strip, @text)
      else
        attr_result
      end
    end
  end

end
