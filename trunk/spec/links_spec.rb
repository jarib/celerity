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
      @browser.links.length.should == 4
    end
  end

  describe "#[]" do
    it "should return the link at the given index" do
      @browser.links[3].id.should == "link_3"
    end

    it "should ... when the index is out of bouds" do
      pending
    end
  end

  describe "#each" do
    it "should iterate through links correctly" do
      index = 0
      @browser.links.each do |c|
        index += 1
        c.name.should == @browser.link(:index, index).name
        c.id.should == @browser.link(:index, index).id
        c.value.should == @browser.link(:index, index).value
      end
      @browser.links.length.should == index
    end
  end

  after :all do
    @browser.close
  end

end

