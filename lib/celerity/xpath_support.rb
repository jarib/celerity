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
      element_from_dom_node(obj)
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
      objects.map { |o| element_from_dom_node(o) }.compact
    end

    #
    # Convert the given HtmlUnit DomNode to a Celerity object
    #

    def element_from_dom_node(obj)
      element_class = Util.htmlunit2celerity(obj.class) || Element
      element_class.new(self, :object, obj)
    end


  end

end
