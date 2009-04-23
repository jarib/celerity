module Celerity
  module ClickableElement

    #
    # click the element
    #

    def click
      assert_exists_and_enabled
      rescue_status_code_exception { @container.update_page(@object.click) }
    end

    #
    # double click the element (Celerity only)
    #

    def double_click
      assert_exists_and_enabled
      rescue_status_code_exception { @container.update_page(@object.dblClick) }
    end

    #
    # right click the element (Celerity only)
    #

    def right_click
      assert_exists_and_enabled
      rescue_status_code_exception { @container.update_page(@object.rightClick) }
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
      
      rescue_status_code_exception { browser.update_page(@object.click) }

      browser
    end
    
    # 
    # Click the element and just return the content as IO. Current page stays unchanged.
    # 
    # @return [IO]
    # 
    
    def download
      assert_exists_and_enabled
      @object.click.getWebResponse.getContentAsStream.to_io
    end

    private

    def assert_exists_and_enabled
      assert_exists
      assert_enabled if respond_to?(:assert_enabled)
    end
  end
end
