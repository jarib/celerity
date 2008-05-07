module Celerity
  class Element
    include Exception
    include Container
    attr_accessor :container, :object
    
    # HTML 4.01 Transitional DTD
    CELLHALIGN_ATTRIBUTES = [:align, :char, :charoff]
    CELLVALIGN_ATTRIBUTES = [:valign]
    CORE_ATTRIBUTES = [:class, :id, :style, :title] # Not valid in base, head, html, meta, param, script, style, and title elements.
    I18N_ATTRIBUTES = [:dir, :lang] # Not valid in base, br, frame, frameset, hr, iframe, param, and script elements.
    EVENT_ATTRIBUTES = [:onclick, :ondblclick, :onmousedown, :onmouseup, :onmouseover, :onmousemove, :onmouseout, :onkeypress, :onkeydown, :onkeyup]
    SLOPPY_ATTRIBUTES = [:name, :value]
    BASE_ATTRIBUTES = CORE_ATTRIBUTES | I18N_ATTRIBUTES | EVENT_ATTRIBUTES | SLOPPY_ATTRIBUTES
    ATTRIBUTES = BASE_ATTRIBUTES
    
    class Identifier < Struct.new(:tag, :attributes)
      def initialize(t, a={}); super(t, a); end
    end

    def initialize(container, *args)
      set_container container
      process_arguments(*args)
    end
    
    def process_arguments(*args)
      if args.size == 1 #&& !args.first.kind_of?(Hash) #(support multiple attributes)
        raise ArgumentError, "wrong number of arguments (1 for 2), DEFAULT_HOW not defined" unless defined? self.class::DEFAULT_HOW
        raise NotImplementedError if args[0].class == Hash
        @how = self.class::DEFAULT_HOW
        @what = args.shift
      else
        @how, @what = *args
      end
    end
    
    def locate
        @object = @container.locate_tagged_element(self, @how, @what)
    end
    
    def to_s
      assert_exists
      create_string(@object)
    end

    # number of spaces that separate the property from the value in the create_string method
    TO_S_SIZE = 14
    
    def create_string(element)
      n = []
      n << "tag:".ljust(TO_S_SIZE) + element.getTagName if element.getTagName.length > 0
      iterator = element.getAttributeEntriesIterator
      while (iterator.hasNext)
        attribute = iterator.next
        n << "  #{attribute.getName}:".ljust(TO_S_SIZE+2) + attribute.getHtmlValue.to_s
      end
      n << "  text:".ljust(TO_S_SIZE+2) + element.asText if element.asText.length > 0
      return n.join("\n")
    end
    
    def attribute_value(attribute)
      assert_exists
      @object.getAttribute(attribute)
    end

    def assert_exists
      locate if defined?(locate)
      unless @object
        raise UnknownObjectException, "Unable to locate object, using #{@how.inspect} and #{@what.inspect}"
      end
    end

    def exists?
      begin
        assert_exists
        true
      rescue UnknownObjectException
        false
      end
    end
    alias_method :exist?, :exists?
    alias_method :exists, :exists?

    def text
      assert_exists
      @object.asText.strip
    end
    alias_method :innerText, :text
    alias_method :inner_text, :text

    def to_xml
      assert_exists
      @object.asXml
    end
    alias_method :asXml, :to_xml
    alias_method :as_xml, :to_xml
    alias_method :html, :to_xml
    
    # used to get attributes
    def method_missing(meth, *args, &blk)
      assert_exists
      meth = :class if meth == :class_name
      meth = :value if meth == :caption
      
      if self.class::ATTRIBUTES.include?(meth)
        @object.getAttributeValue(meth.to_s)
      else
        Log.info "Element\#method_missing calling super with #{meth.inspect}"
        super
      end
    end
    
  end # Element
end # Celerity
