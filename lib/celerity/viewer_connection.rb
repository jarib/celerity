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
      send_data({'method' => 'render_html', 'html' => html, 'url' => url}.to_json)
    end

    def save(path = nil)
      send_data({'method' => 'save', 'path' => path}.to_json)
    end

    def close
      @socket.close
    end

    private

    def send_data(data)
      @socket.write ["Content-Length: #{data.size}", data].join("\n\n")
    end

  end
end