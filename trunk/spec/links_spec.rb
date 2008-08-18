require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Links" do
  
  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/non_control_elements.html")
  end

  describe "#length" do
    it "should return the number of links" do
      @browser.links.length.should == 3
    end
  end
  
  describe "#[]" do
    it "should return the link at the given index" do
      @browser.links[3].id.should == "link_3"
    end
  end

  describe "#each" do
    it "should iterate through links correctly" do
      index = 1
      @browser.links.each do |c|
        c.name.should == @browser.link(:index, index).name
        c.id.should == @browser.link(:index, index).id
        c.value.should == @browser.link(:index, index).value
        index += 1
      end
      @browser.links.length.should == index - 1
    end
  end

  after :all do
    @browser.close
  end

end

