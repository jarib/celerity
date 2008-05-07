require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Form" do
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)
  end

  before :each do
   @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  describe "#exists" do
    it "should return true if the form exists" do
      @ie.form(:id, 'new_user').should exist
      @ie.form(:id, /new_user/).should exist
      @ie.form(:class, 'user').should exist
      @ie.form(:class, /user/).should exist
      @ie.form(:method, 'post').should exist
      @ie.form(:method, /post/).should exist
      @ie.form(:action, 'forms_with_input_elements.html').should exist
      @ie.form(:action, /forms_with_input_elements.html/).should exist
      @ie.form(:index, 1).should exist
      @ie.form(:xpath, "//form[@id='new_user']").should exist
    end
    it "should return false if the form doesn't exist" do
      @ie.form(:id, 'no_such_id').should_not exist
      @ie.form(:id, /no_such_id/).should_not exist
      @ie.form(:class, 'no_such_class').should_not exist
      @ie.form(:class, /no_such_class/).should_not exist
      @ie.form(:method, 'no_such_method').should_not exist
      @ie.form(:method, /no_such_method/).should_not exist
      @ie.form(:action, 'no_such_action').should_not exist
      @ie.form(:action, /no_such_action/).should_not exist
      @ie.form(:index, 1337).should_not exist
      @ie.form(:xpath, "//form[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when what argument is invalid" do
      lambda { @ie.form(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when how argument is invalid" do
      lambda { @ie.form(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  describe "#submit" do
    it "should submit the form" do
      @ie.form(:id, "delete_user").submit
      @ie.text.should include("Semantic table")
    end
  end
    
end  