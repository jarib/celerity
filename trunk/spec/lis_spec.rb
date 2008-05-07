require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Lis" do
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/non_control_elements.html")
  end

  describe "#length" do
    it "should return the number of lis" do
      @ie.lis.length.should == 7
    end
  end
  
  describe "#[]" do
    it "should return the p at the given index" do
      @ie.lis[5].id.should == "non_link_1"
    end
  end

  describe "#each" do
    it "should iterate through lis correctly" do
      @ie.lis.each_with_index do |l, index|
        l.name.should == @ie.li(:index, index+1).name
        l.id.should == @ie.li(:index, index+1).id
        l.value.should == @ie.li(:index, index+1).value
      end
    end
  end
  
  after :all do
    @ie.close
  end

end

