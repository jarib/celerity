require File.dirname(__FILE__) + '/spec_helper.rb'

describe Maps do
  
  before :all do
    @browser = IE.new
    add_spec_checker(@browser)    
  end

  before :each do
    @browser.goto(TEST_HOST + "/images.html")
  end

  describe "#length" do
    it "should return the number of maps" do
      @browser.maps.length.should == 2
    end
  end
  
  describe "#[]" do
    it "should return the p at the given index" do
      @browser.maps[1].id.should == "triangle_map"
    end
  end

  describe "#each" do
    it "should iterate through maps correctly" do
      @browser.maps.each_with_index do |m, index|
        m.name.should == @browser.map(:index, index+1).name
        m.id.should == @browser.map(:index, index+1).id
        m.value.should == @browser.map(:index, index+1).value
      end
    end
  end
  
  after :all do
    @browser.close
  end

end

