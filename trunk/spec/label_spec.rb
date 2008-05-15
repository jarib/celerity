require File.dirname(__FILE__) + '/spec_helper.rb'

# TODO: specs for exceptions

describe "Label" do
  
  before :all do
    @browser = IE.new
    add_spec_checker(@browser)    
  end

  before :each do
    @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  # Exists method
  describe "#exists?" do
    it "should return true if the element exists" do
      @browser.label(:id, 'first_label').should exist
      @browser.label(:id, /first_label/).should exist
      @browser.label(:text, 'First name').should exist
      @browser.label(:text, /First name/).should exist
      @browser.label(:index, 1).should exist
      @browser.label(:xpath, "//label[@id='first_label']").should exist
     end
    it "should return false if the element does not exist" do
      @browser.label(:id, 'no_such_id').should_not exist
      @browser.label(:id, /no_such_id/).should_not exist
      @browser.label(:text, 'no_such_text').should_not exist
      @browser.label(:text, /no_such_text/).should_not exist
      @browser.label(:index, 1337).should_not exist
      @browser.label(:xpath, "//input[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.label(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.label(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#id" do
    it "should return the id attribute if the label exists" do
      @browser.label(:index, 1).id.should == "first_label"
    end
    it "should raise UnknownObjectException if the label doesn't exist" do
      lambda { @browser.label(:index, 1337).id }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#for" do
    it "should return the 'for' attribute if the label exists" do
      @browser.label(:index, 1).for.should == "new_user_first_name"
    end
    it "should raise UnknownObjectException if the label doesn't exist" do
      lambda { @browser.label(:index, 1337).for }.should raise_error(UnknownObjectException)  
    end
  end
  
  after :all do
    @browser.close
  end
end

