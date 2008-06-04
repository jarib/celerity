module CelerityViewer
  class Application
    def initialize
      org.lobobrowser.main.PlatformInit.getInstance.init(false, false)
      org.lobobrowser.main.PlatformInit.getInstance.initLogging(false)
      
      @frame = LoboFrame.new
      @frame.setDefaultCloseOperation(Swing::JFrame::DISPOSE_ON_CLOSE);
      @frame.setSize(600, 400)
      @frame.setVisible(true)
    end
    
    def method_missing(meth, *args, &blk)
      @frame.send(meth, *args, &blk)
    end
    
  end
end