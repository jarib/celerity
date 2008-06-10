module Celerity
  class Browser
    include Container
    attr_accessor :page, :object
    attr_reader :charset, :webclient
    
    def self.start(uri)
      browser = new
      browser.goto(uri)
      browser
    end
    
    # Creates a browser object. 
    #
    # ==== Options (opts)
    # :javascript_exceptions<true, false, nil>::
    #   Throw exceptions on script errors. Disabled by default.
    # :status_code_exceptions<true, false, nil>::
    #   Throw exceptions on failing status codes (404++). Disabled by default.
    # :css<true, false, nil>::
    #   Enable CSS. Disabled by default.
    # :secure_ssl<true, false, nil>::
    #   Disable secure SSL. Enabled by default.
    # :log_level<:trace, :debug, :info, :warn, :error, or :fatal>::
    #   Set the log level for Apache Jakarta commons logging system (used by HtmlUnit)
    #   Defaults to :warn. (not working..)
    # ==== Returns
    # An instance of Celerity::Browser
    #
    #-- 
    # @public
    def initialize(opts = {})
      @opts = opts
      java.lang.System.getProperties.put("org.apache.commons.logging.simplelog.defaultlog", opts[:log_level] ? opts[:log_level].to_s : "warn")
      # java.lang.Logger.getLogger("org.apache.commons.logging.simplelog.defaultlog")

      browser = RUBY_PLATFORM =~ /java/ ? ::HtmlUnit::BrowserVersion::FIREFOX_2 : ::HtmlUnit::BrowserVersion.FIREFOX_2
      @webclient = ::HtmlUnit::WebClient.new(browser)
      @webclient.throwExceptionOnScriptError = false       unless opts[:javascript_exceptions]
      @webclient.throwExceptionOnFailingStatusCode = false unless opts[:status_code_exceptions]
      @webclient.cssEnabled = false                        unless opts[:css]
      @webclient.useInsecureSSL = true                     if opts[:secure_ssl] 
      # @webclient.setAjaxController(::HtmlUnit::NicelyResynchronizingAjaxController.new());

      @last_url, @page = nil
      @page_container  = self
      @error_checkers  = []
      find_viewer 
    end

    def goto(uri)
      uri = "http://#{uri}" unless uri =~ %r{^https?://}
      self.page = @webclient.getPage(uri)
      uri
    end
    
    def close
      @page = nil
    end

    def page=(value)
      @last_url = url() if exist?
      @page = value
      if @page.respond_to?("getDocumentElement")
        @object = @page.getDocumentElement
      end
      render if @viewer
      run_error_checks
    end

    def url
      assert_exists
      @page.getWebResponse.getUrl.toString
    end
    
    def title
      @page ? @page.getTitleText : ''
    end

    def html
      @page ? @page.getWebResponse.getContentAsString : ''
    end

    def text
      if @page.respond_to?("getContent")
        @page.getContent
      else
        @page ? @page.getFirstByXPath("//body").asText : ''
      end
    end
    
    def document
      @object
    end
    
    def back
      # FIXME: this is naive, need capability from HtmlUnit  
      goto(@last_url) if @last_url
    end
    
    def refresh
      assert_exists
      self.page = @page.refresh
    end

    def exist?
      !!@page
    end
    alias_method :exists?, :exist?

    # check that we have a @page object
    # need to find a better way to handle this
    def assert_exists
      raise UnknownObjectException, "no page loaded" unless exist?
    end
    
    def contains_text(expected_text)
      return nil unless exist?
      case expected_text
      when Regexp
        text().match(expected_text)
      when String
        text().index(expected_text)
      else
        raise ArgumentError, "Argument #{expected_text.inspect} should be a String or Regexp."
      end
    end
    
    def execute_script(source)
      assert_exists
      @page.executeJavaScript(source.to_s)
    end
    
    def run_error_checks
      @error_checkers.each { |e| e.call(self) }
    end
    
    def add_checker(checker = nil, &block)
      if block_given?
        @error_checkers << block
      elsif Proc === checker
        @error_checkers << checker
      else
        raise ArgumentError, "argument must be a Proc or block"
      end
    end
    
    def disable_checker(checker)
      @error_checkers.delete(checker)
    end
    
    def method_missing(meth, *args)
      if type = meth.to_s[/^show_(.*)$/, 1]
        begin
          puts collection_string(type)
        rescue NoMethodError
          super
        end
      else
        super
      end
    end
    
    private
    
    def collection_string(collection_method)
      collection = self.send collection_method
      buffer = "Found #{collection.size} divs\n"
      collection.each_with_index do |div, index|
        buffer += "#{index+1}: #{div.attribute_string}\n"
      end
      return buffer
    end
    
    def render
      @viewer.render_html(html, url) 
    rescue DRb::DRbConnError, Errno::ECONNREFUSED => e
      @viewer = nil
    end    
    
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