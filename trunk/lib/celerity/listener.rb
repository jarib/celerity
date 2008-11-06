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
    end

    # Add a listener block for one of the available types.
    # @see Celerity::Browser#add_listener
    def add_listener(type, &block)
      case type
      when :status
        @webclient.setStatusHandler(self)
        (@statuses ||= []) << block
      when :alert
        @webclient.setAlertHandler(self)
        (@alerts ||= []) << block
      when :web_window_event
        @webclient.addWebWindowListener(self)
        (@web_window_events ||= []) << block
      when :html_parser
        @webclient.setHTMLParserListener(self)
        (@html_parsers ||= []) << block
      when :incorrectness
        @webclient.setIncorrectnessListener(self)
        (@incorrects ||= []) << block
      end
    end

    # interface StatusHandler
    def statusMessageChanged(page, message)
      @statuses.each { |h| h.call(page, message) }
    end

    # interface AlertHandler
    def handleAlert(page, message)
      @alerts.each { |h| h.call(page, message) }
    end

    # interface WebWindowListener
    def webWindowClosed(web_window_event)
      @web_window_events.each { |h| h.call(web_window_event) }
    end
    alias_method :webWindowOpened, :webWindowClosed
    alias_method :webWindowContentChanged, :webWindowClosed

    # interface HTMLParserListener
    def error(message, url, line, column, key)
      @html_parsers.each { |h| h.call(message, url, line, column, key) }
    end
    alias_method :warning, :error

    # interface IncorrectnessListener
    def notify(message, origin)
      @incorrects.each { |h| h.call(message, origin) }
    end

  end # Listener
end # Celerity
