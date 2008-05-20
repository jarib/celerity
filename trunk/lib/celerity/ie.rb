module Celerity
  class IE
    include Container
    attr_accessor :page, :object, :webclient
    
    def self.start(uri)
      browser = new
      browser.goto(uri)
      browser
    end
    
    
    # Creates a browser object. 
    #
    # ==== Options (opts)
    # :javascript_exceptions<true, false, nil>::
    #   Throw exceptions on script errors.
    # :css<true, false, nil>::
    #   Enable CSS. Disabled by default.
    # :secure_ssl<true, false, nil>::
    #   Disable secure SSL. Enabled by default.
    #
    # ==== Returns
    # An instance of Celerity::IE
    #
    #-- 
    # @public
    def initialize(opts = {})
      @page_container  = self
      @error_checkers  = []
      @last_url, @page = nil

      browser = RUBY_PLATFORM =~ /java/ ? ::HtmlUnit::BrowserVersion::FIREFOX_2 : ::HtmlUnit::BrowserVersion.FIREFOX_2
      @webclient = ::HtmlUnit::WebClient.new(browser)
      @webclient.setThrowExceptionOnScriptError(false) unless $DEBUG || opts[:javascript_exceptions]
      @webclient.setCssEnabled(false) if opts[:css] == false
      @webclient.setUseInsecureSSL(true) if opts[:secure_ssl] 
    end

    def goto(uri)
      uri = "http://#{uri}" unless uri =~ %r{^https?://}
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
      uri = URI.parse( url() )
      "#{uri.scheme}://#{uri.host}"
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
    
    def collection_string(collection_method)
      collection = self.send collection_method
      buffer = "Found #{collection.size} divs\n"
      collection.each_with_index do |div, index|
        buffer += "#{index+1}: #{div.attribute_string}\n"
      end
      return buffer
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
    
    def method_missing(meth, *args)
      match_data = /^show_(.*)$/.match(meth.to_s)
      if match_data
        begin
          puts collection_string(match_data[1])
        rescue NoMethodError
          super
        end
      else
        super
      end
    end    
    
  end # IE
end # Celerity

Celerity::Browser = Celerity::IE