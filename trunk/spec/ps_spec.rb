require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Ps" do
  
  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/non_control_elements.html")
  end

  describe "#length" do
    it "should return the number of ps" do
      @browser.ps.length.should == 5
    end
  end
  
  describe "#[]" do
    it "should return the p at the given index" do
      @browser.ps[1].id.should == "lead"
    end
  end

  describe "#each" do
    it "should iterate through ps correctly" do
      @browser.ps.each_with_index do |p, index|
        p.name.should == @browser.p(:index, index+1).name
        p.id.should == @browser.p(:index, index+1).id
        p.value.should == @browser.p(:index, index+1).value
      end
    end
  end
  
  after :all do
    @browser.close
  end

end

