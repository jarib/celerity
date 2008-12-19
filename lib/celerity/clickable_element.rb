module Celerity
  module ClickableElement

    # clicks the element
    def click
      assert_exists
      assert_enabled if respond_to?(:assert_enabled)

      @container.update_page(@object.click)
    end

    # Click the element and return a new Browser instance with the resulting page.
    # This is useful for elements that trigger popups when clicked.
    #
    # @return [Celerity::Browser]
    def click_and_attach
      assert_exists
      assert_enabled if respond_to?(:assert_enabled)

      browser = Browser.new
      browser.update_page(@object.click)

      browser
    end
  end
end
