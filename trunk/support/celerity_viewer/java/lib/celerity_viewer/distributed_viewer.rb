require "uri"

class DistributedViewer

  def initialize(browser)
    @browser = browser
    @temp_file = File.expand_path("temp.html")
  end

  def render_html(html, url = nil)
    if url
      uri = URI.parse(url)
      base_url = "#{uri.scheme}://#{uri.host}"
      # hack to get images/css rendering
      html = %Q{<base href="#{base_url}" />\n#{html}}
    end
    
    File.open(@temp_file, "w") do |f|
      f << html
    end
    @browser.goto(@temp_file)
  end

  def print(path = nil)
    raise NotImplementedError
  end

end