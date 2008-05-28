require File.dirname(__FILE__) + '/spec_helper.rb'

describe H1s, H2s, H3s, H4s, H5s, H6s do
  
  before :all do
    @browser = IE.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/non_control_elements.html")
  end

  describe "#length" do
    it "should return the number of h1s" do
      @browser.h2s.length.should == 8
    end
  end
  
  describe "#[]" do
    it "should return the p at the given index" do
      @browser.h1s[1].id.should == "first_header"
    end
  end

  describe "#each" do
    it "should iterate through ps correctly" do
      @browser.h2s.each_with_index do |h, index|
        h.name.should == @browser.h2(:index, index+1).name
        h.id.should == @browser.h2(:index, index+1).id
        h.value.should == @browser.h2(:index, index+1).value
      end
    end
  end
  
  after :all do
    @browser.close
  end

end

