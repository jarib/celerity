require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Links" do
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/non_control_elements.html")
  end

  describe "#length" do
    it "should return the number of links" do
      @ie.links.length.should == 3
    end
  end
  
  describe "#[]" do
    it "should return the link at the given index" do
      @ie.links[3].id.should == "link_3"
    end
  end

  describe "#each" do
    it "should iterate through links correctly" do
      index = 1
      @ie.links.each do |c|
        c.name.should == @ie.link(:index, index).name
        c.id.should == @ie.link(:index, index).id
        c.value.should == @ie.link(:index, index).value
        index += 1
      end
      @ie.links.length.should == index - 1
    end
  end

  after :all do
    @ie.close
  end

end

