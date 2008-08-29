require "drb"
require "drb/acl"
require "uri"

DRb.install_acl(ACL.new(%w{deny all allow 127.0.0.1}))

class DistributedViewer
  attr_reader :web_view
  
  def initialize(controller, web_view, url_field)
    @controller = controller
    @web_view   = web_view
    @url_field  = url_field
  end
    
  def render_html(html, url = nil)
    if url
      uri = URI.parse(url)
      base_url = "#{uri.scheme}://#{uri.host}"
      @url_field.setStringValue(url)
      url = NSURL.URLWithString(base_url)
    end
    @web_view.mainFrame.loadHTMLString_baseURL(html, url)
    @controller.bump_count
  rescue => e
    log(e)
  end
  
  def print(path = nil)
    if path
      viewport = @web_view.mainFrame.frameView.documentView
      viewport_bounds = viewport.bounds 
      image_rep = viewport.bitmapImageRepForCachingDisplayInRect(viewport_bounds)
      viewport.cacheDisplayInRect_toBitmapImageRep(viewport_bounds, image_rep)
      image_rep.representationUsingType_properties(NSPNGFileType, nil).writeToFile_atomically(path, true)
    else
      @web_view.print(nil)
    end
  end
  
end