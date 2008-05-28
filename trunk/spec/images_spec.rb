require File.dirname(__FILE__) + '/spec_helper.rb'

describe Images do
  
  before :all do
    @browser = IE.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/images.html")
  end
  
  describe "#length" do
    it "should return the number of images" do
      @browser.images.length.should == 9
    end
  end
  
  describe "#[]" do
    it "should return the image at the given index" do
      @browser.images[6].id.should == "square"
    end
  end

  describe "#each" do
    it "should iterate through images correctly" do
      @browser.images.each_with_index do |c, index|
        c.name.should == @browser.image(:index, index+1).name
        c.id.should == @browser.image(:index, index+1).id
        c.value.should == @browser.image(:index, index+1).value
      end
    end
  end
  
  after :all do
    @browser.close
  end

end
