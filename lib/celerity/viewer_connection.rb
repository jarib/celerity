module Celerity
  class ViewerConnection

    def self.create(host, port)
      socket = TCPSocket.new(host, port)
      require "json"
      new(socket)
    end

    def initialize(socket)
      @socket = socket
    end

    def render_html(html, url)
      send_data({'method' => 'page_changed', 'html' => html, 'url' => url}.to_json)
    end

    def save(path = nil)
      send_data({'method' => 'save', 'path' => path}.to_json)
    end

    def close
      @socket.close rescue nil
    end

    private

    def send_data(json)
      data = "Content-Length: #{json.size}\n\n#{json}"
      @socket.write data
      @socket.flush
    end

  end
end