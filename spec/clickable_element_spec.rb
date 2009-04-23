require File.dirname(__FILE__) + '/spec_helper.rb'

describe "ClickableElement" do

  before :all do
    @browser = Browser.new(BROWSER_OPTIONS.merge(:log_level => :off))
  end

  before :each do
    @browser.goto(HTML_DIR + "/non_control_elements.html")
  end
  
  describe "#click_and_attach" do
    
    it 'should open a page in a browser with the same options and cookies' do
      browser = @browser.link(:name, /bad_attribute/).click_and_attach
      browser.text.include?("User administration").should be_true # to make sure it is open.
      browser.options.should == @browser.options
      browser.cookies.should == @browser.cookies
    end
    
  end
  
  describe "#download" do
    
    it 'should return a click-opened page as io' do
      @browser.link(:name, /bad_attribute/).download.read.should == open(HTML_DIR + "forms_with_input_elements.html").read
      @browser.link(:name, /bad_attribute/).should be_true # to make sure the browser is still on the same page.
    end
    
  end
  
end
