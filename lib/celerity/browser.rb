module Celerity
  class Browser
    include Container

    attr_accessor :page, :object, :charset
    attr_reader :webclient, :viewer, :options

    #
    # Initialize a browser and go to the given URL
    #
    # @param [String] uri The URL to go to.
    # @return [Celerity::Browser] instance.
    #

    def self.start(uri)
      browser = new
      browser.goto(uri)
      browser
    end

    #
    # Not implemented. Use ClickableElement#click_and_attach instead.
    #

    def self.attach(*args)
      raise NotImplementedError, "use ClickableElement#click_and_attach instead"
    end

    #
    # Creates a browser object.
    #
    # @see Celerity::Container for an introduction to the main API.
    #
    # @option opts :log_level [Symbol] (:warning) @see log_level=
    # @option opts :browser [:firefox, :internet_explorer] (:internet_explorer) Set the BrowserVersion used by HtmlUnit. Defaults to Internet Explorer.
    # @option opts :css [Boolean] (false) Enable CSS.  Disabled by default.
    # @option opts :secure_ssl [Boolean] (true)  Disable secure SSL. Enabled by default.
    # @option opts :resynchronize [Boolean] (false) Use HtmlUnit::NicelyResynchronizingAjaxController to resynchronize Ajax calls.
    # @option opts :javascript_exceptions [Boolean] (false) Raise exceptions on script errors. Disabled by default.
    # @option opts :status_code_exceptions [Boolean] (false) Raise exceptions on failing status codes (404 etc.). Disabled by default.
    # @option opts :render [:html, :xml] (:html) What DOM representation to send to connected viewers.
    # @option opts :charset [String] ("UTF-8") Specify the charset that webclient will use for requests, and those where texts are getting gibberished, like Browser#html.
    # @option opts :proxy [String] (nil) Proxy server to use, in address:port format.
    # @option opts :user_agent [String] Override the User-Agent set by the :browser option
    #
    # @return [Celerity::Browser]     An instance of the browser.
    #
    # @api public
    #

    def initialize(opts = {})
      unless opts.is_a?(Hash)
        raise TypeError, "wrong argument type #{opts.class}, expected Hash"
      end

      unless (render_types = [:html, :xml, nil]).include?(opts[:render])
        raise ArgumentError, "expected one of #{render_types.inspect} for key :render"
      end

      @options = opts.dup # for ClickableElement#click_and_attach

      @render_type   = opts.delete(:render)    || :html
      @charset       = opts.delete(:charset)   || "UTF-8"
      self.log_level = opts.delete(:log_level) || :warning

      @last_url, @page = nil
      @error_checkers  = []
      @browser         = self # for Container#browser

      setup_webclient(opts)

      raise ArgumentError, "unknown option #{opts.inspect}" unless opts.empty?
      find_viewer
    end

    def inspect
      short_inspect :exclude => %w[@webclient @browser @object @options]
    end

    #
    # Goto the given URL
    #
    # @param [String] uri The url.
    # @return [String] The url.
    #

    def goto(uri)
      uri = "http://#{uri}" unless uri =~ %r{://}

      request = HtmlUnit::WebRequestSettings.new(::Java::JavaNet::URL.new(uri))
      request.setCharset(@charset)

      rescue_status_code_exception do
        self.page = @webclient.getPage(request)
      end

      url()
    end

    #
    # Set the credentials used for basic HTTP authentication. (Celerity only)
    #
    # Example:
    #   browser.credentials = "username:password"
    #
    # @param [String] A string with username / password, separated by a colon
    #

    def credentials=(string)
      user, pass = string.split(":")
      dcp = HtmlUnit::DefaultCredentialsProvider.new
      dcp.addCredentials(user, pass)
      @webclient.setCredentialsProvider(dcp)
    end

    #
    # Unsets the current page / closes all windows
    #

    def close
      @page = nil
      @webclient.closeAllWindows
    end

    #
    # @return [String] the URL of the current page
    #

    def url
      assert_exists
      @page.getWebResponse.getRequestUrl.toString
    end

    #
    # @return [String] the title of the current page
    #

    def title
      @page ? @page.getTitleText : ''
    end

    #
    # @return [String] the value of window.status
    #

    def status
      execute_script "window.status" # avoid the listener overhead
    end

    #
    # @return [String] the HTML content of the current page
    #

    def html
      @page ? @page.getWebResponse.getContentAsString(@charset) : ''
    end

    #
    # @return [String] the XML representation of the DOM
    #

    def xml
      return '' unless @page
      return @page.asXml if @page.respond_to?(:asXml)
      return text # fallback to text (for exampel for "plain/text" pages)
    end

    #
    # @return [String] a text representation of the current page
    #

    def text
      return '' unless @page

      if @page.respond_to?("getContent")
        string = @page.getContent.strip
      elsif @page.documentElement
        string = @page.documentElement.asText.strip
      else
        string = ''
      end

      # Celerity::Util.normalize_text(string)
      string
    end

    #
    # @return [Hash] response headers as a hash
    #

    def response_headers
      return {} unless @page

      Hash[*@page.getWebResponse.getResponseHeaders.map { |obj| [obj.name, obj.value] }.flatten]
    end

    #
    # @return [Fixnum] status code of the last request
    #

    def status_code
      @page.getWebResponse.getStatusCode
    end

    #
    # @return [String] content-type as in 'text/html'
    #

    def content_type
      return '' unless @page

      @page.getWebResponse.getContentType
    end

    #
    # @return [IO, nil] page contents as an IO, returns nil if no page is loaded.
    #

    def io
      return nil unless @page

      @page.getWebResponse.getContentAsStream.to_io
    end

    #
    # Check if the current page contains the given text.
    #
    # @param  [String, Regexp] expected_text The text to look for.
    # @return [Numeric, nil]  The index of the matched text, or nil if it isn't found.
    # @raise  [TypeError]
    #

    def contains_text(expected_text)
      return nil unless exist?
      super
    end

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
    # @return [HtmlUnit::HtmlHtml] the underlying HtmlUnit document.
    #

    def document
      @object
    end

    #
    # Goto the last url - HtmlUnit doesn't have a 'back' functionality, so we only have 1 history item :)
    # @return [String, nil] The url of the resulting page, or nil if none was stored.
    #

    def back
      # TODO: this is naive, need capability from HtmlUnit
      goto(@last_url) if @last_url
    end

    #
    # Wait for javascript jobs to finish
    #

    def wait
      assert_exists
      @webclient.waitForBackgroundJavaScript(10000);
    end

    #
    # Refresh the current page
    #

    def refresh
      assert_exists
      self.page = @page.refresh
    end

    #
    # Clears all cookies. (Celerity only)
    #

    def clear_cookies
      @webclient.getCookieManager.clearCookies
    end

    #
    # Clears the cache of "compiled JavaScript files and parsed CSS snippets"
    #

    def clear_cache
      @webclient.cache.clear
    end

    #
    # Get the cookies for this session. (Celerity only)
    #
    # @return [Hash<domain, Hash<name, value>>]
    #

    def cookies
      result = Hash.new { |hash, key| hash[key] = {} }

      cookies = @webclient.getCookieManager.getCookies
      cookies.each do |cookie|
        result[cookie.getDomain][cookie.getName] = cookie.getValue
      end

      result
    end

    #
    # Add a cookie with the given parameters (Celerity only)
    #
    # @param [String] domain
    # @param [String] name
    # @param [String] value
    #
    # @option opts :path    [String]  ("/") A path
    # @option opts :max_age [Fixnum]  (??) A max age
    # @option opts :secure  [Boolean] (false)
    #

    def add_cookie(domain, name, value, opts = {})
      path    = opts.delete(:path) || "/"
      max_age = opts.delete(:max_age) || (Time.now + 60*60*24) # not sure if this is correct
      secure  = opts.delete(:secure) || false

      raise "unknown option: #{opts.inspect}" unless opts.empty?

      cookie = Cookie.new(domain, name, value, path, max_age, secure)
      @webclient.getCookieManager.addCookie(cookie)
    end

    #
    # Remove the cookie with the given domain and name (Celerity only)
    #
    # @param [String] domain
    # @param [String] name
    #

    def remove_cookie(domain, name)
      cm = @webclient.getCookieManager
      cookie = cm.getCookies.find { |c| c.getDomain == domain && c.getName == name }

      if cookie.nil?
        raise "no cookie with domain #{domain.inspect} and name #{name.inspect}"
      end

      cm.removeCookie(cookie)
    end

    #
    # Execute the given JavaScript on the current page.
    # @return [Object] The resulting Object
    #

    def execute_script(source)
      assert_exists
      @page.executeJavaScript(source.to_s).getJavaScriptResult
    end

    # experimental - should be removed?
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

    #
    # Wait until the given block evaluates to true (Celerity only)
    #
    # @param [Fixnum] timeout Number of seconds to wait before timing out (default: 30).
    # @yieldparam [Celerity::Browser] browser The browser instance.
    # @see Celerity::Browser#resynchronized
    #

    def wait_until(timeout = 30, &block)
      returned = nil

      Timeout.timeout(timeout) do
        until returned = yield(self)
          refresh_page_from_window
          sleep 0.1
        end
      end

      returned
    end

    #
    # Wait while the given block evaluates to true (Celerity only)
    #
    # @param [Fixnum] timeout Number of seconds to wait before timing out (default: 30).
    # @yieldparam [Celerity::Browser] browser The browser instance.
    # @see Celerity::Browser#resynchronized
    #

    def wait_while(timeout = 30, &block)
      returned = nil

      Timeout.timeout(timeout) do
        while returned = yield(self)
          refresh_page_from_window
          sleep 0.1
        end
      end

      returned
    end

    #
    # Allows you to temporarily switch to HtmlUnit's NicelyResynchronizingAjaxController
    # to resynchronize ajax calls.
    #
    #   @browser.resynchronized do |b|
    #     b.link(:id, 'trigger_ajax_call').click
    #   end
    #
    # @yieldparam [Celerity::Browser] browser The current browser object.
    # @see Celerity::Browser#new for how to configure the browser to always use this.
    #

    def resynchronized(&block)
      old_controller = @webclient.ajaxController
      @webclient.setAjaxController(::HtmlUnit::NicelyResynchronizingAjaxController.new)
      yield self
      @webclient.setAjaxController(old_controller)
    end

    #
    # Allows you to temporarliy switch to HtmlUnit's default AjaxController, so
    # ajax calls are performed asynchronously. This is useful if you have created
    # the Browser with :resynchronize => true, but want to switch it off temporarily.
    #
    # @yieldparam [Celerity::Browser] browser The current browser object.
    # @see Celerity::Browser#new
    #

    def asynchronized(&block)
      old_controller = @webclient.ajaxController
      @webclient.setAjaxController(::HtmlUnit::AjaxController.new)
      yield self
      @webclient.setAjaxController(old_controller)
    end

    #
    # Start or stop HtmlUnit's DebuggingWebConnection. (Celerity only)
    # The output will go to /tmp/«name»
    #
    # @param [Boolean] bool start or stop
    # @param [String]  name required if bool is true
    #

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

    #
    # Add a listener block for one of the available types. (Celerity only)
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
    # Examples:
    #
    #   browser.add_listener(:status) { |page, message| ... }
    #   browser.add_listener(:alert) { |page, message| ... }
    #   browser.add_listener(:web_window_event) { |web_window_event| ... }
    #   browser.add_listener(:html_parser) { |message, url, line, column, key| ... }
    #   browser.add_listener(:incorrectness) { |message, origin| ... }
    #   browser.add_listener(:confirm) { |page, message| ...; true }
    #   browser.add_listener(:prompt) { |page, message| ... }
    #
    #
    # @param [Symbol] type One of the above symbols.
    # @param [Proc] block A block to be executed for events of this type.
    #

    def add_listener(type, &block)
      listener.add_listener(type, &block)
    end

    #
    # Specify a boolean value to click either 'OK' or 'Cancel' in any confirm
    # dialogs that might show up during the duration of the given block.
    #
    # (Celerity only)
    #
    # @param [Boolean] bool true to click 'OK', false to click 'cancel'
    # @param [Proc] block A block that will trigger the confirm() call(s).
    #

    def confirm(bool, &block)
      blk = lambda { bool }

      listener.add_listener(:confirm, &blk)
      yield
      listener.remove_listener(:confirm, blk)
    end

    #
    # Add a 'checker' proc that will be run on every page load
    #
    # @param [Proc] checker The proc to be run (can also be given as a block)
    # @yieldparam [Celerity::Browser] browser The current browser object.
    # @raise [ArgumentError] if no Proc or block was given.
    #

    def add_checker(checker = nil, &block)
      if block_given?
        @error_checkers << block
      elsif Proc === checker
        @error_checkers << checker
      else
        raise ArgumentError, "argument must be a Proc or block"
      end
    end

    #
    # Remove the given checker from the list of checkers
    # @param [Proc] checker The Proc to disable.
    #

    def disable_checker(checker)
      @error_checkers.delete(checker)
    end

    #
    # :finest, :finer, :fine, :config, :info, :warning, :severe, or :off, :all
    #
    # @return [Symbol] the current log level
    #

    def log_level
      Celerity::Util.logger_for('com.gargoylesoftware.htmlunit').level.to_s.downcase.to_sym
    end

    #
    # Set Java log level (default is :warning, can be any of :all, :finest, :finer, :fine, :config, :info, :warning, :severe, :off)
    #
    # @param [Symbol] level The new log level.
    #

    def log_level=(level)
      log_level = java.util.logging.Level.const_get(level.to_s.upcase)

      [ 'com.gargoylesoftware.htmlunit',
        'com.gargoylesoftware.htmlunit.html',
        'com.gargoylesoftware.htmlunit.javascript',
        'org.apache.commons.httpclient'
      ].each { |package| Celerity::Util.logger_for(package).level = log_level }

      level
    end

    #
    # Checks if we have a page currently loaded.
    # @return [true, false]
    #

    def exist?
      !!@page
    end
    alias_method :exists?, :exist?

    #
    # Turn on/off javascript exceptions
    #
    # @param [Bool]
    #

    def javascript_exceptions=(bool)
      @webclient.throwExceptionOnScriptError = bool
    end

    def javascript_exceptions
      @webclient.throwExceptionOnScriptError
    end

    #
    # Turn on/off status code exceptions
    #
    # @param [Bool]
    #

    def status_code_exceptions=(bool)
      @webclient.throwExceptionOnFailingStatusCode = bool
    end

    def status_code_exceptions
      @webclient.throwExceptionOnFailingStatusCode
    end

    #
    # Turn on/off CSS loading
    #
    # @param [Bool]
    #

    def css=(bool)
      @webclient.cssEnabled = bool
    end

    def css
      @webclient.cssEnabled
    end

    #
    # Turn on/off secure SSL
    #
    # @param [Bool]
    #

    def secure_ssl=(bool)
      @webclient.useInsecureSSL = !bool
    end

    def secure_ssl
      !@webclient.useInsecureSSL
    end

    #
    # Sets the current page object for the browser
    #
    # @param [HtmlUnit::HtmlPage] value The page to set.
    # @api private
    #

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

    #
    # Check that we have a @page object.
    #
    # @raise [Celerity::Exception::UnknownObjectException] if no page is loaded.
    # @api private
    #

    def assert_exists
      raise UnknownObjectException, "no page loaded" unless exist?
    end

    #
    # Returns the element that currently has the focus (Celerity only)
    #

    def focused_element
      element_from_dom_node(page.getFocusedElement())
    end

    private

    #
    # Runs the all the checker procs added by +add_checker+
    #
    # @see add_checker
    # @api private
    #

    def run_error_checks
      @error_checkers.each { |e| e[self] }
    end

    #
    # Configure the webclient according to the options given to #new.
    # @see initialize
    #

    def setup_webclient(opts)
      browser = (opts.delete(:browser) || :firefox).to_sym

      case browser
      when :firefox, :ff, :ff2
        browser_version = ::HtmlUnit::BrowserVersion::FIREFOX_2
      when :firefox3, :ff3
        browser_version = ::HtmlUnit::BrowserVersion::FIREFOX_3
      when :internet_explorer, :ie
        browser_version = ::HtmlUnit::BrowserVersion::INTERNET_EXPLORER_7
      else
        raise ArgumentError, "unknown browser: #{browser.inspect}"
      end

      if ua = opts.delete(:user_agent)
        browser_version.setUserAgent(ua)
      end

      if proxy = opts.delete(:proxy)
        phost, pport = proxy.split(":")
        @webclient = ::HtmlUnit::WebClient.new(browser_version, phost, pport.to_i)
      else
        @webclient = ::HtmlUnit::WebClient.new(browser_version)
      end

      self.javascript_exceptions  = false unless opts.delete(:javascript_exceptions)
      self.status_code_exceptions = false unless opts.delete(:status_code_exceptions)
      self.css                    = false unless opts.delete(:css)
      self.secure_ssl             = opts.delete(:secure_ssl) == false
      @webclient.setAjaxController(::HtmlUnit::NicelyResynchronizingAjaxController.new) if opts.delete(:resynchronize)
    end

    #
    # This *should* be unneccessary, but sometimes the page we get from the
    # window is different (ie. a different object) from our current @page
    # (Used by #wait_while and #wait_until)
    #

    def refresh_page_from_window
      new_page = @page.getEnclosingWindow.getEnclosedPage

      if new_page && (new_page != @page)
        self.page = new_page
      else
        Log.debug "unneccessary refresh"
      end
    end

    #
    # Render the current page on the viewer.
    # @api private
    #

    def render
      @viewer.render_html(self.send(@render_type), url)
    rescue DRb::DRbConnError, Errno::ECONNREFUSED => e
      @viewer = DefaultViewer
    end

    #
    # Check if we have a viewer available on druby://127.0.0.1:6429
    # @api private
    #

    def find_viewer
      # needed to avoid DRb raising and rescuing lots exceptions
      DRb.start_service unless DRb.primary_server

      viewer = DRbObject.new_with_uri("druby://127.0.0.1:6429")
      if viewer.respond_to?(:render_html)
        @viewer = viewer
      else
        @viewer = DefaultViewer
      end
    rescue DRb::DRbConnError, Errno::ECONNREFUSED
      @viewer = DefaultViewer
    end

    #
    # Convert the given HtmlUnit object to a Celerity object
    #

    def element_from_dom_node(obj)
      element_class = Celerity::Util.htmlunit2celerity(obj.class) || Element
      element_class.new(self, :object, obj)
    end

    def listener
      @listener ||= Celerity::Listener.new(@webclient)
    end

  end # Browser
end # Celerity
