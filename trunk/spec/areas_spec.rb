require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Areas" do
  
  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/images.html")
  end

  describe "#length" do
    it "should return the number of areas" do
      @browser.areas.length.should == 3
    end
  end
  
  describe "#[]" do
    it "should return the area at the given index" do
      @browser.areas[1].id.should == "NCE"
    end
  end

  describe "#each" do
    it "should iterate through areas correctly" do
      @browser.areas.each_with_index do |a, index|
        a.name.should == @browser.area(:index, index+1).name
        a.id.should == @browser.area(:index, index+1).id
        a.value.should == @browser.area(:index, index+1).value
      end
    end
  end
  
  after :all do
    @browser.close
  end

end

