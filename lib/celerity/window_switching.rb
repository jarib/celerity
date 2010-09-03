module Celerity
  module WindowSwitching

    def windows(*args)
      all = all_windows

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

    def all_windows
      @webclient.getTopLevelWindows.map { |w| Window.new(self, w) }
    end

    def filter_windows(args, all, method)
      sel = extract_selector(args)
      sel.delete(:index)

      if sel.empty?
        return all.find { |e| e.current? }
      end

      unless sel.keys.all? { |k| [:title, :url].include? k }
        raise ArgumentError, "invalid window selector: #{sel.inspect}"
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

    def inspect
      '#<%s:0x%x id=%s>' % [self.class, hash*2, @window.to_s]
    end

    def current?
      @browser.webclient.getCurrentWindow == @window
    end

    def close
      @window.close
      set_window first_non_closed_window
    end

    def title
      @window.getEnclosedPage.getTitleText
    end

    def url
      @window.getEnclosedPage.getWebResponse.getWebRequest.getUrl.toString
    end

    def use(&blk)
      if current?
        yield if block_given?
        return
      end

      if block_given?
        old_window = current_window
        set_window @window
        res = yield
        set_window old_window

        return res
      end

      set_window @window
      self
    end

    private

    def set_window(window)
      @browser.webclient.setCurrentWindow(window)
      @browser.page = window.getEnclosedPage
    end

    def current_window
      @browser.webclient.getCurrentWindow.getTopWindow
    end

    def first_non_closed_window
      win = @browser.webclient.getWebWindows.find { |w| !w.isClosed }
      win or raise Exception::CelerityException, "no windows left open"
    end
  end # Window
end # Celerity
