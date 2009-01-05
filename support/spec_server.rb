require 'webrick'
require 'webrick/httpproxy'
require 'webrick/https'

module Celerity

  class PostHandler < WEBrick::HTTPServlet::AbstractServlet
    def do_POST(req, resp)
      resp['content-type'] = 'text/html'
      resp.body << "You posted the following content:\n"
      resp.body << req.body
    end
  end

  class PlainTextHandler < WEBrick::HTTPServlet::AbstractServlet
    def do_GET(req, resp)
      resp['content-type'] = 'text/plain'
      resp.body << "This is text/plain"
    end
  end

  class OctetStreamHandler < WEBrick::HTTPServlet::AbstractServlet
    def do_GET(req, resp)
      resp['content-type'] = 'application/octet-stream'
      resp.body << "This is application/octet-stream"
    end
  end


  class SlowAjaxHandler < WEBrick::HTTPServlet::AbstractServlet
    def do_GET(req, resp)
      sleep 10
      resp['content-type'] = 'text/html'
      resp.body << "A slooow ajax response"
    end
  end

  class CharsetMismatchHandler < WEBrick::HTTPServlet::AbstractServlet
    def do_GET(req, resp)
      resp['content-type'] = 'text/html; charset=UTF-8'
      resp.body << %q{
        <html>
          <head>
            <meta http-equiv="Content-type" content="text/html; charset=iso-8859-1" />
          </head>
          <body>
            <h1>ø</h1>
          </body>
        </html>
      }
    end
  end

  class SpecServer
    attr_reader :host, :thread, :log_file

    def initialize(opts = {})
      @ssl      = opts[:ssl] || false
      @doc_root = opts[:doc_root] || File.join(File.dirname(__FILE__),"..", "spec", "html")
      @log_file = opts[:log_file] || File.join(File.dirname(__FILE__), "..", "log", "webrick_log.txt")
      @port     = opts[:port] || 2000
    end

    def run
      unless File.exist?(@log_file)
        FileUtils.mkdir_p(File.dirname(@log_file))
        FileUtils.touch(@log_file)
      end

      server_options = {
         :Port         => @port,
         :DocumentRoot => @doc_root,
         :Logger       => WEBrick::Log.new(@log_file, WEBrick::BasicLog::WARN),
         :AccessLog    => [],
      }

      if @ssl
        # java complains about this certifcate, need to create our own (when running under MRI)
        server_options.merge!(
          :SSLEnable       => true,
          :SSLVerifyClient => ::OpenSSL::SSL::VERIFY_NONE,
          :SSLCertName     => [["CN", "Celerity"]]
        )
        @host = "https://localhost:#{@port}"
      else
        @host = "http://localhost:#{@port}"
      end

      server = WEBrick::HTTPServer.new(server_options)
      server.mount("/", WEBrick::HTTPServlet::FileHandler, @doc_root, {:FancyIndexing=>true})
      server.mount("/post_to_me", PostHandler)
      server.mount("/plain_text", PlainTextHandler)
      server.mount("/ajax", SlowAjaxHandler)
      server.mount("/charset_mismatch", CharsetMismatchHandler)
      server.mount("/octet_stream", OctetStreamHandler)

      @thread = Thread.new { server.start }
    end
  end
end