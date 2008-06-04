class DistributedViewer
  
  def initialize(browser)
    @browser = browser
    @temp_file = File.expand_path("temp.html")
  end

  def render_html(html, base_url = nil)
    # haven't found a way to just render the given HTML string yet 
    File.open(@temp_file, "w") { |f| f << html }
    @browser.goto(@temp_file)
  end
  
  def print(path = nil)
    raise NotImplementedError
  end
  
end