require File.dirname(__FILE__) + '/spec_helper.rb'

describe Ols do
  
  before :all do
    @browser = IE.new
    add_spec_checker(@browser)    
  end

  before :each do
    @browser.goto(TEST_HOST + "/non_control_elements.html")
  end

  describe "#length" do
    it "should return the number of ols" do
      @browser.ols.length.should == 2
    end
  end
  
  describe "#[]" do
    it "should return the ol at the given index" do
      @browser.ols[1].id.should == "favorite_compounds"
    end
  end

  describe "#each" do
    it "should iterate through ols correctly" do
      @browser.ols.each_with_index do |ul, index|
        ul.name.should == @browser.ol(:index, index+1).name
        ul.id.should == @browser.ol(:index, index+1).id
        ul.value.should == @browser.ol(:index, index+1).value
      end
    end
  end
  
  after :all do
    @browser.close
  end

end

