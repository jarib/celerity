module Celerity

  #
  # Used internally to locate elements on the page.
  #

  class ElementLocator
    include Celerity::Exception
    attr_accessor :idents


    def initialize(container, element_class)
      container.assert_exists

      @container     = container
      @object        = container.object
      @element_class = element_class
      @attributes    = @element_class::ATTRIBUTES # could check for 'strict' here?
      @idents        = @element_class::TAGS
      @tags          = @idents.map { |e| e.tag.downcase }
    end

    def find_by_conditions(conditions) # TODO: refactor without performance hit
      return nil unless @object # probably means we're on a TextPage (content-type is "text/plain")

      @condition_idents = []
      attributes = Hash.new { |h, k| h[k] = [] }
      index = 0 # by default, return the first matching element
      text = nil

      conditions.each do |how, what|
        case how
        when :object
          unless what.is_a?(HtmlUnit::Html::HtmlElement) || what.nil?
            raise ArgumentError, "expected an HtmlUnit::Html::HtmlElement subclass, got #{what.inspect}:#{what.class}"
          end
          return what
        when :xpath
          return find_by_xpath(what)
        when :label
          return find_by_label(what) unless @attributes.include?(:label)
        when :class_name
          how = :class
        when :url
          how = :href
        when :caption
          how = :text
        end

        if how == :id && conditions.size == 1
          return find_by_id(what)
        elsif @attributes.include?(how = how.to_sym)
          attributes[how] << what
        elsif how == :index
          index = what.to_i - Celerity.index_offset
        elsif how == :text
          text = what
        else
          raise MissingWayOfFindingObjectException, "No how #{how.inspect}"
        end
      end

      @idents.each do |ident|
        merged = attributes.merge(ident.attributes) { |key, v1, v2| v1 | v2 }
        id = Identifier.new(ident.tag, merged)
        id.text = ident.text || text # «original» identifier takes precedence for :text
        @condition_idents << id
      end

      if index == 0
        element_by_idents(@condition_idents)
      else
        elements_by_idents(@condition_idents)[index]
      end

    rescue HtmlUnit::ElementNotFoundException
      nil # for rcov
    end

    def find_by_id(what)
      case what
      when Regexp
        elements_by_tag_names.find { |elem| elem.getId =~ what }
      when String
        obj = @object.getElementById(what)
        return obj if @tags.include?(obj.getTagName)

        $stderr.puts "warning: multiple elements with identical id? (#{what.inspect})" if $VERBOSE
        elements_by_tag_names.find { |elem| elem.getId == what }
      else
        raise TypeError, "expected String or Regexp, got #{what.inspect}:#{what.class}"
      end
    end

    def find_by_xpath(what)
      what = ".#{what}" if what[0].chr == "/"
      object = @object.getByXPath(what).to_a.first || return

      return unless @idents.any? { |id| id.match?(object) }


      object
    end

    def find_by_label(what)
      obj = elements_by_tag_names(%w[label]).find { |e| Util.matches?(e.asText, what) }

      return nil unless obj && (ref = obj.getReferencedElement)
      return ref if @tags.include?(ref.getTagName)

      find_by_id obj.getForAttribute
    end

    def elements_by_idents(idents = @idents)
      get_by_idents(:select, idents)
    end

    def element_by_idents(idents = @idents)
      get_by_idents(:find, idents)
    end

    private

    def get_by_idents(meth, idents)
      with_nullpointer_retry do
        all_elements.send(meth) do |element|
          next unless @tags.include?(element.getTagName)
          idents.any? { |id| id.match?(element) }
        end
      end
    end

    def elements_by_tag_names(tags = @tags)
      with_nullpointer_retry do
        # HtmlUnit's getHtmlElementsByTagNames won't get elements in the correct
        # order (making :index fail), so we're looping through all elements instead.
        all_elements.select { |elem| tags.include?(elem.getTagName) }
      end
    end

    def all_elements
      unless @object
        raise %{internal error in #{self.class}: @container=#{@container.inspect} @element_class=#{@element_class.inspect}
          Please report this failure and the code/HTML that caused it at http://github.com/jarib/celerity/issues}
      end

      @object.getHtmlElementDescendants
    end

    # HtmlUnit throws NPEs sometimes when we're locating elements
    # Retry seems to work fine.
    def with_nullpointer_retry(max_retries = 3)
      tries = 0
      yield
    rescue java.lang.NullPointerException => e
      raise e if tries >= max_retries

      tries += 1
      warn "warning: celerity caught #{e} - retry ##{tries}"
      retry
    end

  end # ElementLocator
end # Celerity
