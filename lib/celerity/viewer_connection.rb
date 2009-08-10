module Celerity
  class ViewerConnection
    def self.create
      socket = TCPSocket.new('localhost', 6429)
      require "json"
      new(socket)
    end
    
    def initialize(socket)
      @socket = socket
    end
    
    def render_html(html, url)
      data = {'html' => html, 'url' => url}.to_json
      @socket.write "Content-Length: "
      @socket.write data.size.to_s
      @socket.write "\n\n"
      @socket.write data
    end
  end
end