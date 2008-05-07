require "drb"
require File.dirname(__FILE__) + "/../../lib/celerity"


if `uname`.chomp == "Darwin" 
  `open -a CelerityViewer`
  raise "Could not open CelerityViewer" unless $?.success?
  @web_viewer = DRbObject.new_with_uri("druby://127.0.0.1:1337")
  @ie = Celerity::IE.new
  @ie.add_checker do
    @web_viewer.render_html(@ie.object.asXml, @ie.base_url)
  end
  puts "Celerity::IE instance available in @ie"
end
