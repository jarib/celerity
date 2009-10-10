module Celerity

  #
  # This class is used to wrap some of the listeners available from HtmlUnit's WebClient.
  #

  class Listener
    include com.gargoylesoftware.htmlunit.AlertHandler
    include com.gargoylesoftware.htmlunit.ConfirmHandler
    include com.gargoylesoftware.htmlunit.PromptHandler
    include com.gargoylesoftware.htmlunit.html.HTMLParserListener
    include com.gargoylesoftware.htmlunit.IncorrectnessListener
    include com.gargoylesoftware.htmlunit.StatusHandler
    include com.gargoylesoftware.htmlunit.WebWindowListener
    include com.gargoylesoftware.htmlunit.attachment.AttachmentHandler

    def initialize(webclient)
      @webclient = webclient
      @procs = Hash.new { |h, k| h[k] = [] }
    end

    #
    # Add a listener block for one of the available types.
    # @see Celerity::Browser#add_listener
    #

    def add_listener(type, &block)
      case type
      when :status
        @webclient.setStatusHandler(self)
      when :alert
        @webclient.setAlertHandler(self)
      when :attachment
        @webclient.setAttachmentHandler(self)
      when :web_window_event
        @webclient.addWebWindowListener(self)
      when :html_parser
        @webclient.setHTMLParserListener(self)
      when :incorrectness
        @webclient.setIncorrectnessListener(self)
      when :confirm
        @webclient.setConfirmHandler(self)
      when :prompt
        @webclient.setPromptHandler(self)
      else
        raise ArgumentError, "unknown listener type #{type.inspect}"
      end

      @procs[type] << block
    end

    def remove_listener(type, proc_or_index)
      unless @procs.has_key?(type)
        raise ArgumentError, "unknown listener type #{type.inspect}"
      end

      procs = @procs[type]

      case proc_or_index
      when Fixnum
        procs.delete_at proc_or_index
      when Proc
        procs.delete proc_or_index
      else
        raise TypeError, "must give proc or index"
      end
    end

    #
    # interface StatusHandler
    #

    def statusMessageChanged(page, message)
      @procs[:status].each { |handler| handler.call(page, message) }
    end

    #
    # interface AlertHandler
    #

    def handleAlert(page, message)
      @procs[:alert].each { |handler| handler.call(page, message) }
    end

    #
    # interface ConfirmHandler
    #
    # The returned value is determined by the last registered :confirm listener proc.
    # If it is nil, return true, otherwise return that value as a boolean.
    #
    # @see Browser#confirm
    #

    def handleConfirm(page, message)
      val = @procs[:confirm].map { |handler| handler.call(page, message) }.last
      val.nil? || !!val
    end

    #
    # interface AttachmentHandler
    #

    def handleAttachment(page)
      @procs[:attachment].each { |handler| handler.call(page) }
    end

    #
    # interface PromptHandler
    #

    def handlePrompt(page, message)
      @procs[:prompt].each { |handler| handler.call(page, message) }
    end

    #
    # interface WebWindowListener
    #

    def webWindowClosed(web_window_event)
      @procs[:web_window_event].each { |handler| handler.call(web_window_event) }
    end
    alias_method :webWindowOpened, :webWindowClosed
    alias_method :webWindowContentChanged, :webWindowClosed

    #
    # interface HTMLParserListener
    #

    def error(message, url, line, column, key)
      @procs[:html_parser].each { |handler| handler.call(message, url, line, column, key) }
    end
    alias_method :warning, :error

    #
    # interface IncorrectnessListener
    #

    def notify(message, origin)
      @procs[:incorrectness].each { |handler| handler.call(message, origin) }
    end

  end # Listener
end # Celerity
