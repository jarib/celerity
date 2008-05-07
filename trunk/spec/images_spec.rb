require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Images" do
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/images.html")
  end
  
  describe "#length" do
    it "should return the number of images" do
      @ie.images.length.should == 8
    end
  end
  
  describe "#[]" do
    it "should return the image at the given index" do
      @ie.images[6].id.should == "square"
    end
  end

  describe "#each" do
    it "should iterate through images correctly" do
      @ie.images.each_with_index do |c, index|
        c.name.should == @ie.image(:index, index+1).name
        c.id.should == @ie.image(:index, index+1).id
        c.value.should == @ie.image(:index, index+1).value
      end
    end
  end
  
  after :all do
    @ie.close
  end

end
