module Celerity
  class Browser
    include Container
    include XpathSupport

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
    # @option opts :browser [:internet_explorer, :firefox, :firefox3] (:firefox3) Set the BrowserVersion used by HtmlUnit. Defaults to Firefox 3.
    # @option opts :charset [String] ("UTF-8") Specify the charset that webclient will use for requests.
    # @option opts :css [Boolean] (true) Enable/disable CSS.  Enabled by default.
    # @option opts :ignore_pattern [Regexp] See Browser#ignore_pattern=
    # @option opts :javascript_enabled [Boolean] (true)  Enable/disable JavaScript evaluation. Enabled by default.
    # @option opts :javascript_exceptions [Boolean] (false) Raise exceptions on script errors. Disabled by default.
    # @option opts :log_level [Symbol] (:warning) @see log_level=
    # @option opts :proxy [String] (nil) Proxy server to use, in address:port format.
    # @option opts :refresh_handler [:immediate, :waiting, :threaded] (:immediate) Set HtmlUnit's refresh handler.
    # @option opts :render [:html, :xml] (:html) What DOM representation to send to connected viewers.
    # @option opts :resynchronize [Boolean] (false) Use HtmlUnit::NicelyResynchronizingAjaxController to resynchronize Ajax calls.
    # @option opts :secure_ssl [Boolean] (true)  Enable/disable secure SSL. Enabled by default.
    # @option opts :status_code_exceptions [Boolean] (false) Raise exceptions on failing status codes (404 etc.). Disabled by default.
    # @option opts :user_agent [String] Override the User-Agent set by the :browser option
    # @option opts :default_wait [Integer] The default number of seconds to wait when Browser#wait is called.
    # @option opts :viewer [String, false] ("127.0.0.1:6429") Connect to a CelerityViewer if available.
    #
    # @return [Celerity::Browser]     An instance of the browser.
    #
    # @api public
    #

    def initialize(opts = {})
      unless opts.is_a?(Hash)
        raise TypeError, "wrong argument type #{opts.class}, expected Hash"
      end

      unless (render_types = [:html, :xml, nil, 'html', 'xml']).include?(opts[:render])
        raise ArgumentError, "expected one of #{render_types.inspect} for key :render"
      end

      @options = opts.dup # keep the unmodified version around as well
      opts     = opts.dup # we'll delete from opts, so dup to avoid side effects

      @render_type   = opts.delete(:render)    || :html
      @charset       = opts.delete(:charset)   || "UTF-8"
      @page           = nil
      @error_checkers = []
      @browser        = self # for Container#browser

      setup_webclient opts
      setup_viewer opts.delete(:viewer)

      self.log_level = opts.delete(:log_level) || :off

      raise ArgumentError, "unknown option #{opts.inspect}" unless opts.empty?
    end

    def inspect
      short_inspect :exclude => %w[@webclient @browser @object @options @listener @event_listener]
    end

    #
    # Goto the given URL
    #
    # @param [String] uri The url.
    # @param [Hash] (optional) a Hash of HTTP headers to use for the request.
    #
    # @return [String] The url.
    #

    def goto(uri, headers = nil)
      uri = "http://#{uri}" unless uri =~ %r{://}

      request = HtmlUnit::WebRequest.new(::Java::JavaNet::URL.new(uri))

      request.setAdditionalHeaders(headers) if headers
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
      @object = nil
      @webclient.closeAllWindows
      @viewer.close
    end

    #
    # @return [String] the URL of the current page
    #

    def url
      assert_exists
      @page.getWebResponse.getWebRequest.getUrl.toString
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
      return '' unless @page

      @page.getWebResponse.getContentAsString(@charset)
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

      if @page.respond_to?(:getContent)
        @page.getContent.strip
      elsif @page.respond_to?(:getDocumentElement) && doc = @page.getDocumentElement
        doc.asText.strip
      else
        ''
      end
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
    # @return [HtmlUnit::HtmlHtml] the underlying HtmlUnit document.
    #

    def document
      @object
    end

    #
    # Goto back one history item
    # @return [String] The url of the resulting page.
    #

    def back
      @webclient.getCurrentWindow.getHistory.back
      refresh_page_from_window

      url
    end

    #
    # Go forward one history item
    # @return [String] The url of the resulting page.
    #

    def forward
      @webclient.getCurrentWindow.getHistory.forward
      refresh_page_from_window

      url
    end

    #
    # Wait for javascript jobs to finish
    #
    def wait(sec = @default_wait)
      assert_exists
      @webclient.waitForBackgroundJavaScript(sec * 1000);
    end

    #
    # Refresh the current page
    #

    def refresh
      assert_exists
      @page.refresh
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
    # Set the maximum number of files to cache.
    #

    def cache_limit=(size)
      @webclient.cache.setMaxSize(size)
    end

    def cache_limit
      @webclient.cache.getMaxSize
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
    # @option opts :expires [Time]  (1 day from now) An expiration date
    # @option opts :secure  [Boolean] (false)
    #

    def add_cookie(domain, name, value, opts = {})
      path    = opts.delete(:path) || "/"
      max_age = opts.delete(:expires) || (Time.now + 60*60*24) # not sure if this is correct
      secure  = opts.delete(:secure) || false

      raise(ArgumentError, "unknown option: #{opts.inspect}") unless opts.empty?

      cookie = HtmlUnit::Util::Cookie.new(domain, name, value, path, max_age, secure)
      @webclient.getCookieManager.addCookie cookie

      cookie
    end

    #
    # Remove the cookie with the given domain and name (Celerity only)
    #
    # @param [String] domain
    # @param [String] name
    #
    # @raise [CookieNotFoundError] if the cookie doesn't exist
    #

    def remove_cookie(domain, name)
      cm = @webclient.getCookieManager
      cookie = cm.getCookies.find { |c| c.getDomain == domain && c.getName == name }

      if cookie.nil?
        raise CookieNotFoundError, "no cookie with domain #{domain.inspect} and name #{name.inspect}"
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
    # @param [String]  name directory name
    # @param [block]   blk block to execute
    #

    def debug_web_connection(name, &blk)
      old_wc = @webclient.getWebConnection

      @webclient.setWebConnection HtmlUnit::Util::DebuggingWebConnection.new(old_wc, name)
      res = yield
      @webclient.setWebConnection old_wc

      res
    end

    def trace_javascript(debugger_klass = Celerity::JavascriptDebugger, &blk)
      context_factory = @webclient.getJavaScriptEngine.getContextFactory
      context_factory.setDebugger debugger_klass.new
      yield
      context_factory.setDebugger nil
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

    def remove_listener(type, block)
      listener.remove_listener(type, block)
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
    # If a request is made to an URL that matches the pattern set here, Celerity
    # will ignore the request and return an empty page with content type "text/html" instead.
    #
    # This is useful to block unwanted requests (like ads/banners).
    #

    def ignore_pattern=(regexp)
      unless regexp.kind_of?(Regexp)
        raise TypeError, "expected Regexp, got #{regexp.inspect}:#{regexp.class}"
      end

      Celerity::IgnoringWebConnection.new(@webclient, regexp)
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

    def refresh_handler=(symbol)
      handler = case symbol
                when :waiting
                  HtmlUnit::WaitingRefreshHandler.new
                when :threaded
                  HtmlUnit::ThreadedRefreshHandler.new
                when :immediate
                  HtmlUnit::ImmediateRefreshHandler.new
                else
                  raise ArgumentError, "expected :waiting, :threaded or :immediate"
                end

      @webclient.setRefreshHandler handler
    end

    #
    # Turn on/off secure SSL
    #
    # @param [Bool]
    #

    def secure_ssl=(bool)
      @webclient.useInsecureSSL = !bool
    end

    #
    # Turn on/off JavaScript execution
    #
    # @param [Bool]
    #

    def javascript_enabled=(bool)
      @webclient.setJavaScriptEnabled(bool)
    end

    def javascript_enabled
      @webclient.isJavaScriptEnabled
    end

    #
    # Open the JavaScript debugger GUI
    #

    def visual_debugger
      HtmlUnit::Util::WebClientUtils.attachVisualDebugger @webclient
    end

    #
    # Sets the current page object for the browser
    #
    # @param [HtmlUnit::HtmlPage] value The page to set.
    # @api private
    #

    def page=(value)
      return if @page == value
      @page = value

      if @page.respond_to?("getDocumentElement")
        @object = @page.getDocumentElement || @object
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
    # @raise [UnknownObjectException] if no page is loaded.
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

    #
    # Enable Celerity's internal WebWindowEventListener
    #
    # @api private
    #

    def enable_event_listener
      @event_listener ||= lambda do |event|
        self.page = @page ? @page.getEnclosingWindow.getEnclosedPage : event.getNewPage
      end

      listener.add_listener(:web_window_event, &@event_listener)
    end

    #
    # Disable Celerity's internal WebWindowEventListener
    #
    # @api private
    #

    def disable_event_listener
      listener.remove_listener(:web_window_event, @event_listener)

      if block_given?
        result = yield
        enable_event_listener

        result
      end
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
      browser = (opts.delete(:browser) || :firefox3).to_sym

      browser_version = case browser
                        when :firefox, :ff, :firefox3, :ff3 # default :firefox
                          ::HtmlUnit::BrowserVersion::FIREFOX_3
                        when :firefox_3_6, :ff36
                          ::HtmlUnit::BrowserVersion::FIREFOX_3_6
                        when :internet_explorer_6, :ie6
                          ::HtmlUnit::BrowserVersion::INTERNET_EXPLORER_6
                        when :internet_explorer, :ie, :internet_explorer7, :internet_explorer_7, :ie7  # default :ie
                          ::HtmlUnit::BrowserVersion::INTERNET_EXPLORER_7
                        when :internet_explorer_8, :ie8
                          ::HtmlUnit::BrowserVersion::INTERNET_EXPLORER_8
                        else
                          raise ArgumentError, "unknown browser: #{browser.inspect}"
                        end

      if ua = opts.delete(:user_agent)
        browser_version.setUserAgent(ua)
      end

      @webclient = if proxy = opts.delete(:proxy)
                     phost, pport = proxy.split(":")
                     ::HtmlUnit::WebClient.new(browser_version, phost, pport.to_i)
                   else
                     ::HtmlUnit::WebClient.new(browser_version)
                   end

      self.javascript_exceptions  = false unless opts.delete(:javascript_exceptions)
      self.status_code_exceptions = false unless opts.delete(:status_code_exceptions)
      self.css                    = !!opts.delete(:css) if opts.has_key?(:css)
      self.javascript_enabled     = opts.delete(:javascript_enabled) != false
      self.secure_ssl             = opts.delete(:secure_ssl) != false
      self.ignore_pattern         = opts.delete(:ignore_pattern) if opts[:ignore_pattern]
      self.refresh_handler        = opts.delete(:refresh_handler) if opts[:refresh_handler]
      self.cache_limit            = opts.delete(:cache_limit) if opts[:cache_limit]

      @default_wait               = Integer(opts.delete(:default_wait) || 10)

      if opts.delete(:resynchronize)
        controller = ::HtmlUnit::NicelyResynchronizingAjaxController.new
        @webclient.setAjaxController controller
      end

      enable_event_listener
    end

    def setup_viewer(option)
      @viewer = DefaultViewer
      return if option == false

      host_string = option.kind_of?(String) ? option : "127.0.0.1:6429"
      host, port  = host_string.split(":")

      if viewer = ViewerConnection.create(host, port.to_i)
        @viewer = viewer
      end
    rescue Errno::ECONNREFUSED, SocketError => e
      nil
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
    # Render the current page on the connected viewer.
    # @api private
    #

    def render
      @viewer.render_html(self.send(@render_type), url)
    rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::EPIPE
      @viewer = DefaultViewer
    end

    def listener
      @listener ||= Celerity::Listener.new(@webclient)
    end

  end # Browser
end # Celerity
