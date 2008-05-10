require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Areas" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/images.html")
  end

  describe "#length" do
    it "should return the number of areas" do
      @ie.areas.length.should == 3
    end
  end
  
  describe "#[]" do
    it "should return the area at the given index" do
      @ie.areas[1].id.should == "NCE"
    end
  end

  describe "#each" do
    it "should iterate through areas correctly" do
      @ie.areas.each_with_index do |a, index|
        a.name.should == @ie.area(:index, index+1).name
        a.id.should == @ie.area(:index, index+1).id
        a.value.should == @ie.area(:index, index+1).value
      end
    end
  end
  
  after :all do
    @ie.close
  end

end

