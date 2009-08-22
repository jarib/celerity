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
      send_data('method' => 'page_changed', 'html' => html, 'url' => url)
    end

    #
    # Tells the viewer to save a screenshot of the current page to the given path.
    # May not be available on all viewers.
    #

    def save(path)
      send_data('method' => 'save', 'path' => path)
    end


    #
    # Tells the viewer to dump the render tree to the given path.
    # Only available in the Qt viewer.
    #

    def save_render_tree(path)
      send_data('method' => 'save_render_tree', 'path' => path)
    end

    #
    # Get the currently rendered page as a Base64-encoded PNG image.
    # Only available in the Qt viewer.
    #

    def image_data
      send_data('method' => 'image_data')
      data = read_data
      data['image'] || data['error']
    end

    #
    # Close the connection.
    #

    def close
      @socket.close rescue nil
    end

    private

    def send_data(msg)
      json = msg.to_json
      data = "Content-Length: #{json.size}\n\n#{json}"
      @socket.write data
      @socket.flush

      nil
    end

    def read_data
      buf = ''
      until buf =~ /\n\n\z/ || @socket.eof? || @socket.closed?
        buf << @socket.read(1).to_s
      end

      return if buf.empty?

      length = buf[/Content-Length: (\d+)/, 1].to_i
      JSON.parse @socket.read(length)
    end

  end
end