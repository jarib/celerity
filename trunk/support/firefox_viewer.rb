require "net/telnet"
require "uri"
require "drb"
require "drb/acl"

DRb.install_acl(ACL.new(%w{deny all allow 127.0.0.1}))

# To use this viewer, you must install and enable the MozRepl extension for 
# Firefox: http://hyperstruct.net/projects/mozrepl
class FirefoxViewer
  
  def initialize( opts = {})
    @opts = opts
    @verbose = opts[:verbose]
    
    @firefox = Net::Telnet.new(
      "Host"    => "localhost",
      "Timeout" => 5,
      "Port"    => opts[:port] || 4242
    )
    
    render_html("<html><h1>Celerity FirefoxViewer</h1></html>")
  end
  
  
  def render_html(string, url = nil)
    if url
      uri = URI.parse(url)
      string = %Q{<base href="#{uri.scheme}://#{uri.host}">\n#{string}}
    end
    string.gsub!(/<\?xml version="1.0" encoding="ISO-8859-1"\?>/i, 
                 '<?xml version="1.0" encoding="UTF-8"?>')

    string = create_data_uri(string)
    p :string => string if @verbose
    
    execute %Q{content.document.location.href = '#{string.gsub(/(?=['\n])/, "\\\\")}';}
    execute ";"
  end
  
  def print(*args)
    
  end
  
  private
  
  def execute(cmd)
    @firefox.cmd(cmd) do |output|
      puts output if @verbose
    end
    
    nil
  end
  
  def create_data_uri(string)
    string = [string].pack("m").chomp
    string = "data:text/html;charset=UTF-8;base64,#{string}"
  end
  
end

if __FILE__ == $0
  DRb.start_service("druby://127.0.0.1:6429", FirefoxViewer.new(:verbose => true))
  DRb.thread.join
end