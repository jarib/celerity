module Celerity
  module ClickableElement

    #
    # click the element
    #

    def click
      assert_exists_and_enabled
      rescue_status_code_exception { @object.click }
    end

    #
    # double click the element (Celerity only)
    #

    def double_click
      assert_exists_and_enabled
      rescue_status_code_exception { @object.dblClick }
    end

    #
    # right click the element (Celerity only)
    #

    def right_click
      assert_exists_and_enabled
      rescue_status_code_exception { @object.rightClick }
    end

    #
    # Click the element and return a new Browser instance with the resulting page.
    # This is useful for elements that trigger popups when clicked.
    #
    # @return [Celerity::Browser]
    #

    def click_and_attach
      assert_exists_and_enabled
      browser = Browser.new(@browser.options.dup)
      browser.webclient.set_cookie_manager(
        @browser.webclient.get_cookie_manager
      ) # hirobumi: we do want cookies as well.

      @browser.disable_event_listener do
        rescue_status_code_exception { browser.page = @object.click }
      end

      browser
    end

    #
    # Click the element and just return the content as IO. Current page stays unchanged.
    # This can be used to download content that normally isn't rendered in a browser.
    #
    # @return [IO]
    #

    def download
      assert_exists_and_enabled
      @browser.disable_event_listener do
        @object.click.getWebResponse.getContentAsStream.to_io
      end
    end

    private

    def assert_exists_and_enabled
      assert_exists
      assert_enabled if respond_to?(:assert_enabled)
    end
  end
end
