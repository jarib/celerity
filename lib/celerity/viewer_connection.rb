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
      @socket.write ["Content-Length: #{data.size}", data].join("\n\n")
    end
  end
end