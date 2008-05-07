require 'osx/cocoa'
require "distributed_viewer"
include OSX
require_framework 'WebKit'

class MainController < NSObject
	ib_outlets :web_view

	def awakeFromNib
	  DRb.start_service("druby://127.0.0.1:1337", DistributedViewer.new(@web_view))
	end
end


