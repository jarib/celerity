module Celerity
  module WindowSwitching

    def windows(*args)
      all = @webclient.getWebWindows.map { |w| Window.new(self, w) }
      
      if args.empty?
        all
      else
        filter_windows(args, all, :select)
      end
    end
    
    def window(*args, &blk)
      win = filter_windows(args, windows, :find)
      
      if win && block_given?
        win.use(&blk)
      end
      
      win
    end
    
    private
    
    def filter_windows(args, all, method)
      sel = extract_selector(args)
      
      unless sel.keys.all? { |k| [:title, :url].include? k }
        raise ArgumentError, "invalid window selector: #{sel}"
      end

      all.send(method) do |win|
        sel.all? { |key, value| value === win.send(key) }
      end
    end
    
  end # WindowSwitching

  class Window
    def initialize(browser, window)
      @browser = browser
      @window = window
    end

    def current?
      @browser.page == @window.getEnclosedPage
    end

    def close
      raise NotImplementedError, "#{self.class}#close"
    end

    def title
      use { @browser.title }
    end

    def url
      use { @browser.url }
    end

    def use(&blk)
      old_window = @browser.webclient.getCurrentWindow
      
      @browser.webclient.setCurrentWindow(@window)
      @browser.page = @window.getEnclosedPage
      
      if block_given?
        res = yield
        @browser.webclient.setCurrentWindow(old_window)
        @browser.page = old_window.getEnclosedPage
        
        return res
      end
      
      self
    end
  end # Window
end # Celerity
