module Celerity

  #
  # Module to search by xpath
  #

  module XpathSupport

    #
    # Get the first element found matching the given XPath.
    #
    # @param [String] xpath
    # @return [Celerity::Element] An element subclass (or Element if none is found)
    #

    def element_by_xpath(xpath)
      assert_exists
      obj = @page.getFirstByXPath(xpath)
      element_from_dom_node(obj, ":xpath and #{xpath.inspect}")
    end

    #
    # Get all the elements matching the given XPath.
    #
    # @param [String] xpath
    # @return [Array<Celerity::Element>] array of elements
    #

    def elements_by_xpath(xpath)
      assert_exists
      objects = @page.getByXPath(xpath)
      # should use an ElementCollection here?
      objects.map { |o| element_from_dom_node(o) }
    end

    #
    # Convert the given HtmlUnit DomNode to a Celerity object
    #

    def element_from_dom_node(obj, identifier_string = nil)
      element_class = Util.htmlunit2celerity(obj.class) || Element
      element = element_class.new(self, :object, obj)

      element.identifier_string = identifier_string
      element.extend(ClickableElement) unless element.is_a?(ClickableElement)

      element
    end
  end
end
