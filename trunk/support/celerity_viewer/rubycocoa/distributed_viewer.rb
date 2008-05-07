require "drb"
require "drb/acl"

DRb.install_acl(ACL.new(%w{deny all allow 127.0.0.1}))

class DistributedViewer
  
  def initialize(web_view)
    @web_view = web_view
  end
  
  def render_html(html, base_url = nil)
    @web_view.mainFrame.loadHTMLString_baseURL(html, NSURL.URLWithString(base_url))
  end
  
  def print(path = nil)
    if path
      # TODO: fix printing
      rect = @web_view.mainFrame.frameView.documentView.bounds
      view = @web_view.mainFrame.frameView.documentView
      print_operation = NSPrintOperation.PDFOperationWithView_insideRect_toPath_printInfo(view, 
                                                                                          rect,
                                                                                          path,
                                                                                          NSPrintInfo.sharedPrintInfo)
      print_operation.runOperation
    else
      @web_view.print(nil)
    end
  end
  
end