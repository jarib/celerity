module Celerity

  # This class is used to wrap some of HtmlUnit's Listener/Handler interfaces.
  # @see Celerity::Browser#add_listener
  class Listener
    def initialize
      @status_handlers = []
    end

    def statusMessageChanged(page, message)
      @status_handlers.each { |h| h.call(page, message) }
    end

  end # Listener
end # Celerity
