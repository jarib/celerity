module Celerity
  module WindowSwitching
    def window(*args)
    end

    def windows(*args)
      @webclient.getWebWindows.map do |win|
        Window.new(win)
      end
    end
  end # windowSwitching

  class Window
    def initialize(window)
      @window = window
    end

    def current?
      raise NotImplementedError
    end

    def close
      raise NotImplementedError
    end

    def title
      raise NotImplementedError
    end

    def url
      raise NotImplementedError
    end

    def use(&blk)
      raise NotImplementedError
      self
    end
  end # Window
end # Celerity
