require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Maps" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/images.html")
  end

  describe "#length" do
    it "should return the number of maps" do
      @ie.maps.length.should == 2
    end
  end
  
  describe "#[]" do
    it "should return the p at the given index" do
      @ie.maps[1].id.should == "triangle_map"
    end
  end

  describe "#each" do
    it "should iterate through maps correctly" do
      @ie.maps.each_with_index do |m, index|
        m.name.should == @ie.map(:index, index+1).name
        m.id.should == @ie.map(:index, index+1).id
        m.value.should == @ie.map(:index, index+1).value
      end
    end
  end
  
  after :all do
    @ie.close
  end

end

