module Celerity
  class ViewerConnection

    #
    # Create a new connection to the given host/port
    #

    def self.create(host, port)
      # if the connection fails, we won't spend time loading json
      socket = TCPSocket.new(host, port)
      require "json"
      new(socket)
    end

    def initialize(socket)
      @socket = socket
    end

    #
    # Tells the viewer to render the given HTML, with the given URL as base url.
    #

    def render_html(html, url)
      send_data({'method' => 'page_changed', 'html' => html, 'url' => url}.to_json)
    end

    #
    # Tells the viewer to save a screenshot of the current page to the given path.
    # May not be available on all viewers.
    #

    def save(path)
      send_data({'method' => 'save', 'path' => path}.to_json)
    end

    #
    # Tells the viewer to dump the render tree to the given path.
    # Only available on the Qt viewer.
    #

    def save_render_tree(path)
      send_data({'method' => 'save_render_tree', 'path' => path}.to_json)
    end

    #
    # Close the connection.
    #

    def close
      @socket.close rescue nil
    end

    private

    def send_data(json)
      data = "Content-Length: #{json.size}\n\n#{json}"
      @socket.write data
      @socket.flush

      nil
    end

  end
end