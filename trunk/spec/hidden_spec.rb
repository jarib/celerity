require File.dirname(__FILE__) + '/spec_helper.rb'

# TODO: specs for exceptions

describe "Hidden" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  # Exist method
  describe "#exists?" do
    it "should return true if the element exists" do
      @ie.hidden(:id, 'new_user_interests_dolls').should exist
      @ie.hidden(:id, /new_user_interests_dolls/).should exist
      @ie.hidden(:name, 'new_user_interests').should exist
      @ie.hidden(:name, /new_user_interests/).should exist
      @ie.hidden(:value, 'dolls').should exist
      @ie.hidden(:value, /dolls/).should exist
      # TODO: figure out what :text means for Hidden
      # @ie.hidden(:text, 'dolls').should exist
      # @ie.hidden(:text, /dolls/).should exist
      @ie.hidden(:class, 'fun').should exist
      @ie.hidden(:class, /fun/).should exist
      @ie.hidden(:index, 1).should exist
      @ie.hidden(:xpath, "//input[@id='new_user_interests_dolls']").should exist
     end
    it "should return false if the element does not exist" do
      @ie.hidden(:id, 'no_such_id').should_not exist
      @ie.hidden(:id, /no_such_id/).should_not exist
      @ie.hidden(:name, 'no_such_name').should_not exist
      @ie.hidden(:name, /no_such_name/).should_not exist
      @ie.hidden(:value, 'no_such_value').should_not exist
      @ie.hidden(:value, /no_such_value/).should_not exist
      @ie.hidden(:text, 'no_such_text').should_not exist
      @ie.hidden(:text, /no_such_text/).should_not exist
      @ie.hidden(:class, 'no_such_class').should_not exist
      @ie.hidden(:class, /no_such_class/).should_not exist
      @ie.hidden(:index, 1337).should_not exist
      @ie.hidden(:xpath, "//input[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @ie.hidden(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @ie.hidden(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  
  # Attribute methods
  describe "#id" do
    it "should return the id attribute if the text field exists" do
      @ie.hidden(:index, 1).id.should == "new_user_interests_dolls"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.hidden(:index, 1337).id }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#name" do
    it "should return the name attribute if the text field exists" do
      @ie.hidden(:index, 1).name.should == "new_user_interests"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.hidden(:index, 1337).name }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#type" do
    it "should return the type attribute if the text field exists" do
      @ie.hidden(:index, 1).type.should == "hidden"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.hidden(:index, 1337).type }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#value" do
    it "should return the value attribute if the text field exists" do
      @ie.hidden(:index, 1).value.should == "dolls"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.hidden(:index, 1337).value }.should raise_error(UnknownObjectException)  
    end
  end
  
  # Manipulation methods
  describe "#value=" do
    it "should set the value of the element" do
      @ie.hidden(:id, 'new_user_interests_dolls').value = 'guns'
      @ie.hidden(:id, "new_user_interests_dolls").value.should == 'guns'
    end
  end

  after :all do
    @ie.close
  end
end

