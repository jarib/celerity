module Celerity
  class Browser
    include Container
    attr_accessor :page, :object
    attr_reader :webclient, :viewer
    
    # Initialize a browser and goto the given URL
    # @param uri The URL to go to.
    # @return Instance of Celerity::Browser.
    def self.start(uri)
      browser = new
      browser.goto(uri)
      browser
    end
    
    def self.attach(*args)
      raise NotImplementedError, "no popup handling yet"
    end
    
    # Creates a browser object.
    #
    # @param [Hash[Symbol, Object]] Options for initial configuration of the browser.
    # 
    # @option :browser[:firefox, :internet_explorer] Set the BrowserVersion used by HtmlUnit.
    #        Defaults to Internet Explorer.
    # @option :css[true, false, nil] Enable CSS. 
    #        Disabled by default.
    # @option :secure_ssl[true, false, nil] Disable secure SSL. 
    #        Enabled by default.
    # @option :resynchronize[true, false, nil] Use HtmlUnit::NicelyResynchronizingAjaxController to resynchronize Ajax calls.
    # @option :javascript_exceptions[true, false, nil] Throw exceptions on script errors. 
    #        Disabled by default.
    # @option :status_code_exceptions[true, false, nil]Throw exceptions on failing status codes (404 etc.).
    #        Disabled by default.
    #
    # @return [Celerity::Browser]     An instance of the browser.
    # @api public
    def initialize(opts = {})
      raise TypeError, "bad argument: #{opts.inspect}" unless opts.is_a? Hash
      
      @opts            = opts
      @last_url, @page = nil
      @page_container  = self
      @error_checkers  = []
      
      self.log_level = :warning

      browser = @opts[:browser] == :firefox ? 
          ::HtmlUnit::BrowserVersion::FIREFOX_2 : ::HtmlUnit::BrowserVersion::INTERNET_EXPLORER_7_0
          
      @webclient = ::HtmlUnit::WebClient.new(browser)

      configure_webclient
      find_viewer 
    end
        
    # Goto the given URL
    #
    # @param [String] the url
    # @return [String] the url
    def goto(uri)
      uri = "http://#{uri}" unless uri =~ %r{://}
      self.page = @webclient.getPage(uri)
      uri
    end
    
    # Unsets the current page (mostly for Watir compatibility)
    def close
      @page = nil
    end

    # @return [String] the URL of the current page
    def url
      assert_exists
      @page.getWebResponse.getUrl.toString
    end
    
    # @return [String] the title of the current page
    def title
      @page ? @page.getTitleText : ''
    end

    # @return [String] the HTML content of the current page
    def html
      @page ? @page.getWebResponse.getContentAsString : ''
    end

    # @return [String] a text representation of the current page
    def text
      return '' unless @page

      if @page.respond_to?("getContent")
        @page.getContent  
      else
        # # this has minimal whitespace
        @page.documentElement.asText
        
        # if @opts[:browser] == :firefox
        #   # # this is what firewatir does - only works with HtmlUnit::BrowserVersion::FIREFOX_2
        #   res = execute_script("document.body.textContent").getJavaScriptResult 
        # else
        #   # this only works with HtmlUnit::BrowserVersion::INTERNET_EXPLORER_*, and isn't identical to Watir's ole_object.innerText
        #   res = execute_script("document.body.innerText").getJavaScriptResult 
        # end
      end
    end

    # Check if the current page contains the given text.
    #
    # @param  [String, Regexp] expected_text The text to look for.
    # @return [Numeric, nil]  The index of the matched text, or nil if it doesn't match.
    def contains_text(expected_text)
      return nil unless exist?
      case expected_text
      when Regexp
        text() =~ expected_text
      when String
        text().index(expected_text)
      else
        raise ArgumentError, "Argument must be String or Regexp, but was #{expected_text.inspect}:#{expected_text.class}"
      end
    end

    # @return [HtmlUnit::HtmlHtml] the underlying HtmlUnit object.
    def document
      @object
    end
    
    # Goto the last url - HtmlUnit doesn't have a 'back' functionality, so we only have 1 history item :)
    # @return [String, nil] The url of the resulting page, or nil if none was stored.
    def back
      # TODO: this is naive, need capability from HtmlUnit  
      goto(@last_url) if @last_url
    end
    
    # Refresh the current page
    def refresh
      assert_exists
      self.page = @page.refresh
    end

    # Execute the given JavaScript on the current page
    # @return [HtmlUnit::ScriptResult]
    def execute_script(source)
      assert_exists
      @page.executeJavaScript(source.to_s)
    end

    # Add a 'checker' proc that will be run on every page load
    # 
    # @param [Proc] checker the proc to be run (can also be given as a block)
    # @raise [ArgumentError] if no Proc or block was given.
    def add_checker(checker = nil, &block)
      if block_given?
        @error_checkers << block
      elsif Proc === checker
        @error_checkers << checker
      else
        raise ArgumentError, "argument must be a Proc or block"
      end
    end
    
    # Remove the given checker from the list of checkers
    # @param [Proc] the Proc to disable
    def disable_checker(checker)
      @error_checkers.delete(checker)
    end

    # Set Java log level (default is :warning)
    #
    # @param [Symbol] level :finest, :finer, :fine, :config, :info, :warning, :severe, or :off, :all
    def log_level=(level)
      java.util.logging.Logger.getLogger('com.gargoylesoftware.htmlunit').level = java.util.logging.Level.const_get(level.to_s.upcase)
    end
    
    # @return [Symbol] the current log level
    def log_level
      java.util.logging.Logger.getLogger('com.gargoylesoftware.htmlunit').level.to_s.downcase.to_sym
    end

    # Checks if we have a page currently loaded. 
    # @return [true, false]
    def exist?
      !!@page
    end
    alias_method :exists?, :exist?

    # Allows you to temporarily switch to HtmlUnit's NicelyResynchronizingAjaxController to resynchronize ajax calls.
    #
    # Example:
    #   @browser.resynchroniced do |b|
    #     b.link(:id, 'load_fancy_ajax_stuff').click
    #   end
    #
    # @param [block] &block the block to execute synchronized.
    def resynchronized(&block)
      old_controller = @webclient.ajaxController
      @webclient.setAjaxController(::HtmlUnit::NicelyResynchronizingAjaxController.new)
      yield self
      @webclient.setAjaxController(old_controller)
    end

    #--
    # TODO: could be private?
    #++
    #
    # Check that we have a @page object.
    # 
    # @raise UnknownObjectException
    # @api internal
    def assert_exists
      raise UnknownObjectException, "no page loaded" unless exist?
    end
    
    #--
    # TODO: could be private?
    #++
    # Runs the all the checker procs added by +add_checker+
    #
    # @see add_checker
    # @api internal
    def run_error_checks
      @error_checkers.each { |e| e.call(self) }
    end
    
    # Set the current page object for the browser
    #
    # @param [HtmlUnit::HtmlPage] value The page to set.
    # @api internal
    def page=(value)
      @last_url = url() if exist?
      @page = value
      
      if @page.respond_to?("getDocumentElement")
        @object = @page.getDocumentElement
      end
      
      render if @viewer
      run_error_checks
      
      value
    end

    # Used for #show_links(), #show_divs() etc. (for watir compatibility)
    def method_missing(meth, *args)
      return super unless type = meth.to_s[/^show_(.*)$/, 1]
      puts collection_string(type) rescue super
    end

    private
    
    # Configure the webclient according to the options given to #new.
    # @see initialize
    def configure_webclient
      @webclient.throwExceptionOnScriptError = false unless @opts[:javascript_exceptions]
      @webclient.throwExceptionOnFailingStatusCode = false unless @opts[:status_code_exceptions]
      @webclient.cssEnabled = false unless @opts[:css]
      @webclient.useInsecureSSL = true if @opts[:secure_ssl] 
      @webclient.setAjaxController(::HtmlUnit::NicelyResynchronizingAjaxController.new) if @opts[:resynchronize]
    end

    # Create a string representation of all the elements returned by collection_method
    # @param [Symbol] collection_method
    # @return [String] 
    def collection_string(collection_method)
      collection = self.send collection_method
      result = "Found #{collection.size} #{collection_method.downcase}\n"
      
      collection.each_with_index do |element, index|
        result << "#{index+1}: #{element.attribute_string}\n"
      end
      
      result
    end
    
    # Render the current page on the viewer.
    # @api internal
    def render
      @viewer.render_html(html, url) 
    rescue DRb::DRbConnError, Errno::ECONNREFUSED => e
      @viewer = nil
    end    
    
    # Check if we have a viewer available on druby://127.0.0.1:6429
    # @api internal
    def find_viewer
      # FIXME: not ideal
      require 'drb'
      viewer = DRbObject.new_with_uri("druby://127.0.0.1:6429")
      @viewer = viewer if viewer.respond_to?(:render_html)
    rescue DRb::DRbConnError, Errno::ECONNREFUSED
      @viewer = nil
    end
    
  end # Browser
end # Celerity