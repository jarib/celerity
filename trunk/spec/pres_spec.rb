require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Pres" do
  
  before :all do
    @browser = IE.new
    add_spec_checker(@browser)    
  end

  before :each do
    @browser.goto(TEST_HOST + "/non_control_elements.html")
  end

  describe "#length" do
    it "should return the number of pres" do
      @browser.pres.length.should == 7
    end
  end
  
  describe "#[]" do
    it "should return the pre at the given index" do
      @browser.pres[2].id.should == "rspec"
    end
  end

  describe "#each" do
    it "should iterate through pres correctly" do
      @browser.pres.each_with_index do |p, index|
        p.name.should == @browser.pre(:index, index+1).name
        p.id.should == @browser.pre(:index, index+1).id
        p.value.should == @browser.pre(:index, index+1).value
      end
    end
  end
  
  after :all do
    @browser.close
  end

end

