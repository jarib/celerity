require "net/telnet"
require "uri"

require "drb"
require "drb/acl"
require "uri"

DRb.install_acl(ACL.new(%w{deny all allow 127.0.0.1}))

# To use this viewer, you must install and enable the MozRepl extension for 
# Firefox: http://hyperstruct.net/projects/mozrepl
class FirefoxViewer
  
  START = "<html><h1>Celerity FirefoxViewer</h1></html>"
  
  def initialize( opts = {})
    @opts = opts
    @firefox = Net::Telnet.new(
      "Host"    => "localhost",
      "Timeout" => 5,
      "Port"    => opts[:port] || 4242
    )
    
    # execute "window.open('data:text/html,#{URI.escape(START)}')"
    render_html("Celerity FirefoxViewer")
  end
  
  
  def render_html(string, url = nil)
    if url
      uri = URI.parse(url)
      base_url = "#{uri.scheme}://#{uri.host}"
    end
    
    string.gsub!(/<\?xml version="1.0" encoding="ISO-8859-1"\?>/i, '<?xml version="1.0" encoding="UTF-8"?>')
    
    execute %Q{content.document.location.href = 'data:text/html,#{URI.escape(string).gsub("\'", "\\\\\'")}'}
    execute ";"
    # execute %Q{var incoming = document.createElement("html")}
    # execute %Q{incoming.innerHTML = #{string.inspect}}
    # # execute %Q{var root = document.getElementsByTagName("html")[0]}
    # execute %Q{content.document.replaceChild(content.document.documentElement, incoming)}
  end
  
  def print(*args)
    
  end
  
  private
  
  def execute(cmd)
    @firefox.cmd(cmd) do |output|
      puts output if @opts[:verbose]
    end
    
    nil
  end
  
end

if __FILE__ == $0
  DRb.start_service("druby://127.0.0.1:6429", FirefoxViewer.new(:verbose => true))
  DRb.thread.join
end