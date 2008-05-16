require "drb"
require "drb/acl"

DRb.install_acl(ACL.new(%w{deny all allow 127.0.0.1}))

class DistributedViewer
  attr_reader :web_view
  
  def initialize(web_view)
    @web_view = web_view
  end
    
  def render_html(html, base_url = nil)
    @web_view.mainFrame.loadHTMLString_baseURL(html, NSURL.URLWithString(base_url))
  end
  
  def print(path = nil)
    if path
      # TODO: fix printing
      
      # =========
      # = Alt I =
      # =========
      # rect = @web_view.mainFrame.frameView.documentView.bounds
      # view = @web_view.mainFrame.frameView.documentView
      # print_operation = NSPrintOperation.PDFOperationWithView_insideRect_toPath_printInfo(view, 
      #                                                                                     rect,
      #                                                                                     path,
      #                                                                                     NSPrintInfo.sharedPrintInfo)
      # print_operation.runOperation
      
      # ======================================================================
      # = Alt II : http://www.cocoadev.com/index.pl?GettingViewContentAsImage =
      # ======================================================================
      print_info = NSPrintInfo.sharedPrintInfo
      print_info.setJobDisposition(NSPrintSaveJob)
      print_info.dictionary.setObject_forKey(path, NSPrintSavePath) 
      print_info.dictionary.setObject_forKey(1, NSPrintFirstPage) 
      print_info.dictionary.setObject_forKey(1, NSPrintLastPage) 
      print_info.dictionary.setObject_forKey("Letter", NSPrintPaperName) 
      print_info.setBottomMargin(0.0)
      print_info.setTopMargin(0.0)
      print_info.setLeftMargin(0.0)
      print_info.setRightMargin(0.0)
      
      operation = NSPrintOperation.printOperationWithView_printInfo(@web_view.mainFrame.frameView.documentView, print_info)
      operation.setShowPanels(false)
      operation.runOperation
      
      # ===============================================================
      # = Alt III : /Developer/Examples/RubyCocoa/Scripts/darkroom.rb =
      # ===============================================================
      # viewport = @web_view.mainFrame.frameView.documentView
      # log(1)
      # # viewport.window.orderFront(nil)
      # viewport.window.display
      # log(2)
      # # viewport.window.setContentSize(viewport.bounds)
      # viewport.setFrame(viewport.bounds)
      # log(3)
      # viewport.lockFocus
      # log(4)
      # bitmap = NSBitmapImageRep.alloc.initWithFocusedViewRect(viewport.bounds)
      # viewport.unLockFocus
      # log(5)
      # log(bitmap)
      # bitmap.representationUsingType_properties(NSPNGFileType, nil).writeToFile_atomically(path, true)
      # log(6)
    else
      @web_view.print(nil)
    end
  end
  
end