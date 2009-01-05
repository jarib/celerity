module Celerity
  class Browser
    include Container

    attr_accessor :page, :object, :charset
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
      raise NotImplementedError, "use ClickableElement#click_and_attach instead"
    end

    # Creates a browser object.
    #
    # @option opts :log_level [Symbol] (:warning) @see log_level=
    # @option opts :browser [:firefox, :internet_explorer] (:internet_explorer) Set the BrowserVersion used by HtmlUnit. Defaults to Internet Explorer.
    # @option opts :css [Boolean] (false) Enable CSS.  Disabled by default.
    # @option opts :secure_ssl [Boolean] (true)  Disable secure SSL. Enabled by default.
    # @option opts :resynchronize [Boolean] (false) Use HtmlUnit::NicelyResynchronizingAjaxController to resynchronize Ajax calls.
    # @option opts :javascript_exceptions [Boolean] (false) Raise exceptions on script errors. Disabled by default.
    # @option opts :status_code_exceptions [Boolean] (false) Raise exceptions on failing status codes (404 etc.). Disabled by default.
    # @option opts :render [:html, :xml] (:html) What DOM representation to send to connected viewers.
    # @option opts :charset [String] ("UTF-8") Specify the charset that webclient will use by default.
    # @option opts :proxy [String] (nil) Proxy server to use, in address:port format.
    #
    # @return [Celerity::Browser]     An instance of the browser.
    # @see Celerity::Container for a small introduction to the API.
    # @api public
    def initialize(opts = {})
      unless opts.is_a?(Hash)
        raise TypeError, "wrong argument type #{opts.class}, expected Hash"
      end

      unless (render_types = [:html, :xml, nil]).include?(opts[:render])
        raise ArgumentError, "expected one of #{render_types.inspect} for key :render"
      end

      @render_type   = opts.delete(:render)    || :html
      @charset       = opts.delete(:charset)   || "UTF-8"
      @proxy         = opts.delete(:proxy)     || nil
      self.log_level = opts.delete(:log_level) || :warning

      @last_url, @page = nil
      @error_checkers  = []
      @browser         = self # for Container#browser

      browser = case opts.delete(:browser)
                when :firefox then ::HtmlUnit::BrowserVersion::FIREFOX_2
                else               ::HtmlUnit::BrowserVersion::INTERNET_EXPLORER_7_0
                end

      @webclient = ::HtmlUnit::WebClient.new(browser)

      configure_webclient(opts)
      raise ArgumentError, "unknown option #{opts.inspect}" unless opts.empty?
      find_viewer
    end

    # Goto the given URL
    #
    # @param [String] uri The url.
    # @return [String] The url.
    def goto(uri)
      uri = "http://#{uri}" unless uri =~ %r{://}

      request = HtmlUnit::WebRequestSettings.new(::Java::JavaNet::URL.new(uri))
      request.setCharset(@charset)

      self.page = @webclient.getPage(request)

      url()
    end

    # Unsets the current page / closes all windows
    def close
      @page = nil
      @webclient.closeAllWindows
    end

    # @return [String] the URL of the current page
    def url
      assert_exists
      # will be renamed getUrl => getRequestUrl
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

    # @return [String] the XML representation of the DOM
    def xml
      return '' unless @page
      return @page.asXml if @page.respond_to?(:asXml)
      return text # fallback to text (for exampel for "plain/text" pages)
    end

    # @return [String] a text representation of the current page
    def text
      return '' unless @page

      if @page.respond_to?("getContent")
        string = @page.getContent.strip
      else
        string = @page.documentElement.asText.strip
      end

      # Celerity::Util.normalize_text(string)
      string
    end
    
    # @return [Hash] response headers as a hash
    def response_headers
      return {} unless @page
      
      Hash[*@page.getWebResponse.getResponseHeaders.map { |obj| [obj.name, obj.value] }.flatten]
    end
    
    # @return [String] content-type as in 'text/html'
    def content_type
      return '' unless @page
      
      @page.getWebResponse.getContentType
    end
    
    # @return [IO, nil] page contents as an IO, returns nil if no page is loaded.
    def io
      return nil unless @page
      
      @page.getWebResponse.getContentAsStream.to_io
    end

    # Check if the current page contains the given text.
    #
    # @param  [String, Regexp] expected_text The text to look for.
    # @raise  [TypeError]
    # @return [Numeric, nil]  The index of the matched text, or nil if it doesn't match.
    def contains_text(expected_text)
      return nil unless exist?
      super
    end

    #
    # write me!
    #
    def element_by_xpath(xpath)
      assert_exists
      obj = @page.getFirstByXPath(xpath)
      element_from_dom_node(obj)
    end

    #
    # write me!
    #
    def elements_by_xpath(xpath)
      assert_exists
      objects = @page.getByXPath(xpath)
      # should use an ElementCollection here?
      objects.map { |o| element_from_dom_node(o) }.compact
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

    # Wait for ajax calls to finish
    def wait
      assert_exists
      @page.getEnclosingWindow.getThreadManager.joinAll(10000)
    end

    # Refresh the current page
    def refresh
      assert_exists
      self.page = @page.refresh
    end

    # Clears all cookies. (Celerity-specific API)
    def clear_cookies
      @webclient.getCookieManager.clearCookies
    end

    # Execute the given JavaScript on the current page. (Celerity-specific API)
    # @return [Object] The resulting Object
    def execute_script(source)
      assert_exists
      @page.executeJavaScript(source.to_s).getJavaScriptResult
    end

    # experimental
    def send_keys(keys)
      keys = keys.gsub(/\s*/, '').scan(/((?:\{[A-Z]+?\})|.)/u).flatten
      keys.each do |key|
        element = @page.getFocusedElement
        case key
        when "{TAB}"
          @page.tabToNextElement
        when /\w/
          element.type(key)
        else
          raise NotImplementedError
        end
      end
    end

    # Wait until the given block evaluates to true (Celerity-specific API)
    #
    # @param [Fixnum] timeout Number of seconds to wait before timing out (default: 30).
    # @yieldparam [Celerity::Browser] browser The browser instance.
    # @see Celerity::Browser#resynchronized
    def wait_until(timeout = 30, &block)
      Timeout.timeout(timeout) do
        until yield(self)
          refresh_page_from_window
          sleep 0.1
        end
      end
    end

    # Wait while the given block evaluates to true (Celerity-specific API)
    #
    # @param [Fixnum] timeout Number of seconds to wait before timing out (default: 30).
    # @yieldparam [Celerity::Browser] browser The browser instance.
    # @see Celerity::Browser#resynchronized
    def wait_while(timeout = 30, &block)
      Timeout.timeout(timeout) do
        while yield(self)
          refresh_page_from_window
          sleep 0.1
        end
      end
    end

    # Add a 'checker' proc that will be run on every page load
    #
    # @param [Proc] checker The proc to be run (can also be given as a block)
    # @yieldparam [Celerity::Browser] browser The current browser object.
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
    # @param [Proc] checker The Proc to disable.
    def disable_checker(checker)
      @error_checkers.delete(checker)
    end

    # @return [Symbol] the current log level
    def log_level
      java.util.logging.Logger.getLogger('com.gargoylesoftware.htmlunit').level.to_s.downcase.to_sym
    end

    # Set Java log level (default is :warning)
    #
    # @param [Symbol] level :finest, :finer, :fine, :config, :info, :warning, :severe, or :off, :all
    def log_level=(level)
      java.util.logging.Logger.getLogger('com.gargoylesoftware.htmlunit').level = java.util.logging.Level.const_get(level.to_s.upcase)
    end

    # Checks if we have a page currently loaded.
    # @return [true, false]
    def exist?
      !!@page
    end
    alias_method :exists?, :exist?

    # Allows you to temporarily switch to HtmlUnit's NicelyResynchronizingAjaxController to resynchronize ajax calls.
    #
    #   @browser.resynchroniced do |b|
    #     b.link(:id, 'load_fancy_ajax_stuff').click
    #   end
    #
    # @yieldparam [Celerity::Browser] browser The current browser object.
    # @see Celerity::Browser#new for options on how to always use this.
    def resynchronized(&block)
      old_controller = @webclient.ajaxController
      @webclient.setAjaxController(::HtmlUnit::NicelyResynchronizingAjaxController.new)

      yield(self)

      @webclient.setAjaxController(old_controller)
    end

    #--
    # TODO: could be private?
    #++
    #
    # Check that we have a @page object.
    #
    # @raise [Celerity::Exception::UnknownObjectException] if no page is loaded.
    # @api private
    def assert_exists
      raise UnknownObjectException, "no page loaded" unless exist?
    end

    #--
    # TODO: could be private?
    #++
    # Runs the all the checker procs added by +add_checker+
    #
    # @see add_checker
    # @api private
    def run_error_checks
      @error_checkers.each { |e| e[self] }
    end

    # Set the current page object for the browser
    #
    # @param [HtmlUnit::HtmlPage] value The page to set.
    # @api private
    def page=(value)
      @last_url = url() if exist?
      @page = value

      if @page.respond_to?("getDocumentElement")
        @object = @page.getDocumentElement
      elsif @page.is_a? HtmlUnit::UnexpectedPage
        raise UnexpectedPageException, @page.getWebResponse.getContentType
      end

      render unless @viewer == DefaultViewer
      run_error_checks

      value
    end

    # Start or stop HtmlUnit's DebuggingWebConnection.
    # The output will go to /tmp/«name»
    #
    # @param [Boolean] bool start or stop
    # @param [String]  name required if bool is true
    def debug_web_connection(bool, name = nil)
      if bool
        raise "no name given" unless name
        @old_webconnection = @webclient.getWebConnection
        dwc = HtmlUnit::Util::DebuggingWebConnection.new(@old_webconnection, name)
        @webclient.setWebConnection(dwc)
        $stderr.puts "debug-webconnection on"
      else
        @webclient.setWebConnection(@old_webconnection) if @old_webconnection
        $stderr.puts "debug-webconnection off"
      end
    end

    # Add a listener block for one of the available types.
    # Types map to HtmlUnit interfaces like this:
    #
    #   :status           => StatusHandler
    #   :alert            => AlertHandler  ( window.alert() )
    #   :web_window_event => WebWindowListener
    #   :html_parser      => HTMLParserListener
    #   :incorrectness    => IncorrectnessListener
    #   :confirm          => ConfirmHandler ( window.confirm() )
    #   :prompt           => PromptHandler ( window.prompt() )
    #
    #
    # @param [Symbol] type One of the above symbols.
    # @param [Proc] block A block to be executed for events of this type.
    def add_listener(type, &block)
      @listener ||= Celerity::Listener.new(@webclient)
      @listener.add_listener(type, &block)
    end

    private

    # Configure the webclient according to the options given to #new.
    # @see initialize
    def configure_webclient(opts)
      @webclient.throwExceptionOnScriptError = false unless opts.delete(:javascript_exceptions)
      @webclient.throwExceptionOnFailingStatusCode = false unless opts.delete(:status_code_exceptions)
      @webclient.cssEnabled = false unless opts.delete(:css)
      @webclient.useInsecureSSL = opts.delete(:secure_ssl) == false

      if @proxy
        phost, pport = @proxy.split(":")
        @webclient.proxyHost = phost
        @webclient.proxyPort = pport.to_i
      end
      @webclient.setAjaxController(::HtmlUnit::NicelyResynchronizingAjaxController.new) if opts.delete(:resynchronize)
    end

    # This *should* be unneccessary, but sometimes the page we get from the
    # window is different (ie. a different object) from our current @page
    # (Used by #wait_while and #wait_until)
    def refresh_page_from_window
      new_page = @page.getEnclosingWindow.getEnclosedPage

      if new_page && (new_page != @page)
        self.page = new_page
      else
        Log.debug "unneccessary refresh"
      end
    end

    # Render the current page on the viewer.
    # @api private
    def render
      @viewer.render_html(self.send(@render_type), url)
    rescue DRb::DRbConnError, Errno::ECONNREFUSED => e
      @viewer = DefaultViewer
    end

    # Check if we have a viewer available on druby://127.0.0.1:6429
    # @api private
    def find_viewer
      viewer = DRbObject.new_with_uri("druby://127.0.0.1:6429")
      if viewer.respond_to?(:render_html)
        @viewer = viewer
      else
        @viewer = DefaultViewer
      end
    rescue DRb::DRbConnError, Errno::ECONNREFUSED
      @viewer = DefaultViewer
    end

    def element_from_dom_node(obj)
      if element_class = Celerity::Util.htmlunit2celerity(obj.class)
        element_class.new(self, :object, obj)
      else
        Element.new(self, :object, nil)
      end
    end

  end # Browser
end # Celerity
