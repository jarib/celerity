module Celerity

  # This class is used to wrap some of the various listeners available
  # from HtmlUnit's WebClient.
  class Listener
    include com.gargoylesoftware.htmlunit.AlertHandler
    include com.gargoylesoftware.htmlunit.StatusHandler
    include com.gargoylesoftware.htmlunit.WebWindowListener
    include com.gargoylesoftware.htmlunit.html.HTMLParserListener
    include com.gargoylesoftware.htmlunit.IncorrectnessListener

    def initialize(webclient)
      @webclient = webclient
      @procs = Hash.new { |h, k| h[k] = [] }
    end

    # Add a listener block for one of the available types.
    # @see Celerity::Browser#add_listener
    def add_listener(type, &block)
      case type
      when :status
        @webclient.setStatusHandler(self)
      when :alert
        @webclient.setAlertHandler(self)
      when :web_window_event
        @webclient.addWebWindowListener(self)
      when :html_parser
        @webclient.setHTMLParserListener(self)
      when :incorrectness
        @webclient.setIncorrectnessListener(self)
      else
        raise "unknown listener type #{type.inspect}"
      end
      
      @procs[type] << block
    end

    # interface StatusHandler
    def statusMessageChanged(page, message)
      @procs[:status].each { |h| h.call(page, message) }
    end

    # interface AlertHandler
    def handleAlert(page, message)
      @procs[:alert].each { |h| h.call(page, message) }
    end

    # interface WebWindowListener
    def webWindowClosed(web_window_event)
      @procs[:web_window_event].each { |h| h.call(web_window_event) }
    end
    alias_method :webWindowOpened, :webWindowClosed
    alias_method :webWindowContentChanged, :webWindowClosed

    # interface HTMLParserListener
    def error(message, url, line, column, key)
      @procs[:html_parser].each { |h| h.call(message, url, line, column, key) }
    end
    alias_method :warning, :error

    # interface IncorrectnessListener
    def notify(message, origin)
      @procs[:incorrectness].each { |h| h.call(message, origin) }
    end

  end # Listener
end # Celerity
