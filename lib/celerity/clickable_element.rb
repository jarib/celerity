module Celerity
  module ClickableElement

    #
    # click the element
    #

    def click
      assert_exists_and_enabled
      @container.update_page(@object.click)
    end

    #
    # double click the element (Celerity only)
    #

    def double_click
      assert_exists_and_enabled
      @container.update_page(@object.dblClick)
    end

    #
    # right click the element (Celerity only)
    #

    def right_click
      assert_exists_and_enabled
      @container.update_page(@object.rightClick)
    end

    #
    # Click the element and return a new Browser instance with the resulting page.
    # This is useful for elements that trigger popups when clicked.
    #
    # @return [Celerity::Browser]
    #

    def click_and_attach
      assert_exists_and_enabled
      browser = Browser.new(:log_level => @browser.log_level)
      browser.update_page(@object.click)

      browser
    end

    private

    def assert_exists_and_enabled
      assert_exists
      assert_enabled if respond_to?(:assert_enabled)
    end
  end
end
