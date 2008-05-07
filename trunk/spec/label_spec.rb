require File.dirname(__FILE__) + '/spec_helper.rb'

# TODO: specs for exceptions

describe "TextField" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  # Exists method
  describe "#exists?" do
    it "should return true if the element exists" do
      @ie.label(:id, 'first_label').should exist
      @ie.label(:id, /first_label/).should exist
      @ie.label(:text, 'First name').should exist
      @ie.label(:text, /First name/).should exist
      @ie.label(:index, 1).should exist
      @ie.label(:xpath, "//label[@id='first_label']").should exist
     end
    it "should return false if the element does not exist" do
      @ie.label(:id, 'no_such_id').should_not exist
      @ie.label(:id, /no_such_id/).should_not exist
      @ie.label(:text, 'no_such_text').should_not exist
      @ie.label(:text, /no_such_text/).should_not exist
      @ie.label(:index, 1337).should_not exist
      @ie.label(:xpath, "//input[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when what argument is invalid" do
      lambda { @ie.label(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when how argument is invalid" do
      lambda { @ie.label(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#id" do
    it "should return the id attribute if the text field exists" do
      @ie.label(:index, 1).id.should == "first_label"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.label(:index, 1337).id }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#for" do
    it "should return the id attribute if the text field exists" do
      @ie.label(:index, 1).for.should == "new_user_first_name"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.label(:index, 1337).for }.should raise_error(UnknownObjectException)  
    end
  end
  
  after :all do
    @ie.close
  end
end

