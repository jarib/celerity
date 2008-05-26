require File.dirname(__FILE__) + '/spec_helper.rb'

describe Ul do
  
  before :all do
    @browser = IE.new
    add_spec_checker(@browser)    
  end

  before :each do
    @browser.goto(TEST_HOST + "/non_control_elements.html")
  end

  # Exists method
  describe "#exist?" do
    it "should return true if the 'ul' exists" do
      @browser.ul(:id, "navbar").should exist
      @browser.ul(:id, /navbar/).should exist
      @browser.ul(:index, 1).should exist
      @browser.ul(:xpath, "//ul[@id='navbar']").should exist
    end
    it "should return true if the element exists (default how = :id)" do
      @browser.ul("navbar").should exist
    end
    it "should return false if the 'ul' doesn't exist" do
      @browser.ul(:id, "no_such_id").should_not exist
      @browser.ul(:id, /no_such_id/).should_not exist
      @browser.ul(:text, "no_such_text").should_not exist
      @browser.ul(:text, /no_such_text/).should_not exist
      @browser.ul(:class, "no_such_class").should_not exist
      @browser.ul(:class, /no_such_class/).should_not exist
      @browser.ul(:index, 1337).should_not exist
      @browser.ul(:xpath, "//ul[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.ul(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.ul(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#class_name" do
    it "should return the class attribute" do
      @browser.ul(:id, 'navbar').class_name.should == 'navigation'
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.ul(:index, 2).class_name.should == ''
    end
    it "should raise UnknownObjectException if the ul doesn't exist" do
      lambda { @browser.ul(:id, 'no_such_id').class_name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#id" do
    it "should return the id attribute" do
      @browser.ul(:class, 'navigation').id.should == "navbar"
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.ul(:index, 2).id.should == ''
    end
    it "should raise UnknownObjectException if the ul doesn't exist" do
      lambda { @browser.ul(:id, "no_such_id").id }.should raise_error(UnknownObjectException)
      lambda { @browser.ul(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end
  
  after :all do
    @browser.close
  end

end