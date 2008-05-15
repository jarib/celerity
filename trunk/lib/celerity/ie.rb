module Celerity
  class IE
    include Container
    attr_accessor :page, :object, :webclient
    
    def self.start(uri)
      browser = new
      browser.goto(uri)
      browser
    end
    
    def initialize(opts = {})
      @page_container  = self
      @error_checkers  = []
      @last_url, @page = nil

      browser = RUBY_PLATFORM =~ /java/ ? ::HtmlUnit::BrowserVersion::FIREFOX_2 : ::HtmlUnit::BrowserVersion.FIREFOX_2
      @webclient = ::HtmlUnit::WebClient.new(browser)
      @webclient.setThrowExceptionOnScriptError(false) unless $DEBUG || opts[:enable_javascript_exceptions]
      @webclient.setCssEnabled(false) if opts[:disable_css] 
    end

    def goto(uri)
      uri = "http://#{uri}" unless uri =~ %r{^http://}
      set_page @webclient.getPage(uri)
      uri
    end
    
    def close
      @page = nil
    end

    def set_page(value)
      @last_url = url() if exist?
      @page = value
      @object = @page.getDocumentElement
      run_error_checks
    end

    def url
      assert_exists
      @page.getWebResponse.getUrl.toString
    end
    
    def base_url
      # FIXME: base_url HTTPS
      "http://" + URI.parse( url() ).host
    end

    def title
      @page ? @page.getTitleText : ''
    end

    def html
      @page ? @page.getWebResponse.getContentAsString : ''
    end

    def text
      # nicer way to do this?
      @page ? @page.getFirstByXPath("//body").asText : ''
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
      set_page(@page.refresh)
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
    
    # these are just for Watir compatability - should we keep them?
    class << self
      attr_accessor :speed, :attach_timeout, :visible
      alias_method :start_window, :start
      def reset_attach_timeout; @attach_timeout = 2.0; end
      def each; end
      def quit; end
      def set_fast_speed; @speed = :fast; end
      def set_slow_speed; @speed = :slow; end  
    end

    attr_accessor :visible
    def bring_to_front; true; end
    def speed=(s); end
    
  end # IE
end # Celerity

Celerity::Browser = Celerity::IE
