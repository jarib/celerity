require 'osx/cocoa'
require "distributed_viewer"
include OSX
require_framework 'WebKit'

class MainController < NSObject
	ib_outlets :web_view, :text_field

	def awakeFromNib
	  @web_view.preferences.setShouldPrintBackgrounds(true)
	  NSUserDefaults.standardUserDefaults.setObject_forKey('YES', 'WebKitDeveloperExtras')
	  DRb.start_service("druby://127.0.0.1:6429", DistributedViewer.new(@web_view, @text_field))
	end
	
	def load_url(sender)
	  str = sender.stringValue
	  url = NSURL.URLWithString(str.to_ruby =~ /^https?/ ? str : "http://#{str}" )
    @web_view.mainFrame.loadRequest(OSX::NSURLRequest.requestWithURL(url))
  end
  
end


