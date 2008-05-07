require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Pres" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/non_control_elements.html")
  end

  describe "#length" do
    it "should return the number of pres" do
      @ie.pres.length.should == 7
    end
  end
  
  describe "#[]" do
    it "should return the pre at the given index" do
      @ie.pres[2].id.should == "rspec"
    end
  end

  describe "#each" do
    it "should iterate through pres correctly" do
      @ie.pres.each_with_index do |p, index|
        p.name.should == @ie.pre(:index, index+1).name
        p.id.should == @ie.pre(:index, index+1).id
        p.value.should == @ie.pre(:index, index+1).value
      end
    end
  end
  
  after :all do
    @ie.close
  end

end

