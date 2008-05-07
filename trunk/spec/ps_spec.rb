require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Ps" do
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/non_control_elements.html")
  end

  describe "#length" do
    it "should return the number of ps" do
      @ie.ps.length.should == 5
    end
  end
  
  describe "#[]" do
    it "should return the p at the given index" do
      @ie.ps[1].id.should == "lead"
    end
  end

  describe "#each" do
    it "should iterate through ps correctly" do
      @ie.ps.each_with_index do |p, index|
        p.name.should == @ie.p(:index, index+1).name
        p.id.should == @ie.p(:index, index+1).id
        p.value.should == @ie.p(:index, index+1).value
      end
    end
  end
  
  after :all do
    @ie.close
  end

end

