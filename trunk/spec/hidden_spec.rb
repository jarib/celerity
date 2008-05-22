require File.dirname(__FILE__) + '/spec_helper.rb'

describe Hidden do
  
  before :all do
    @browser = IE.new
    add_spec_checker(@browser)    
  end

  before :each do
    @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  # Exist method
  describe "#exists?" do
    it "should return true if the element exists" do
      @browser.hidden(:id, 'new_user_interests_dolls').should exist
      @browser.hidden(:id, /new_user_interests_dolls/).should exist
      @browser.hidden(:name, 'new_user_interests').should exist
      @browser.hidden(:name, /new_user_interests/).should exist
      @browser.hidden(:value, 'dolls').should exist
      @browser.hidden(:value, /dolls/).should exist
      # TODO: figure out what :text means for Hidden
      # @browser.hidden(:text, 'dolls').should exist
      # @browser.hidden(:text, /dolls/).should exist
      @browser.hidden(:class, 'fun').should exist
      @browser.hidden(:class, /fun/).should exist
      @browser.hidden(:index, 1).should exist
      @browser.hidden(:xpath, "//input[@id='new_user_interests_dolls']").should exist
     end
    it "should return true if the element exists (default how = :name)" do
      @browser.hidden("new_user_interests").should exist
    end
    it "should return false if the element does not exist" do
      @browser.hidden(:id, 'no_such_id').should_not exist
      @browser.hidden(:id, /no_such_id/).should_not exist
      @browser.hidden(:name, 'no_such_name').should_not exist
      @browser.hidden(:name, /no_such_name/).should_not exist
      @browser.hidden(:value, 'no_such_value').should_not exist
      @browser.hidden(:value, /no_such_value/).should_not exist
      @browser.hidden(:text, 'no_such_text').should_not exist
      @browser.hidden(:text, /no_such_text/).should_not exist
      @browser.hidden(:class, 'no_such_class').should_not exist
      @browser.hidden(:class, /no_such_class/).should_not exist
      @browser.hidden(:index, 1337).should_not exist
      @browser.hidden(:xpath, "//input[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.hidden(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.hidden(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  
  # Attribute methods
  describe "#id" do
    it "should return the id attribute if the text field exists" do
      @browser.hidden(:index, 1).id.should == "new_user_interests_dolls"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @browser.hidden(:index, 1337).id }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#name" do
    it "should return the name attribute if the text field exists" do
      @browser.hidden(:index, 1).name.should == "new_user_interests"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @browser.hidden(:index, 1337).name }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#type" do
    it "should return the type attribute if the text field exists" do
      @browser.hidden(:index, 1).type.should == "hidden"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @browser.hidden(:index, 1337).type }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#value" do
    it "should return the value attribute if the text field exists" do
      @browser.hidden(:index, 1).value.should == "dolls"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @browser.hidden(:index, 1337).value }.should raise_error(UnknownObjectException)
    end
  end
  
  # Manipulation methods
  describe "#value=" do
    it "should set the value of the element" do
      @browser.hidden(:id, 'new_user_interests_dolls').value = 'guns'
      @browser.hidden(:id, "new_user_interests_dolls").value.should == 'guns'
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @browser.hidden(:id, 'no_such_id').value = 'guns' }.should raise_error(UnknownObjectException)
    end
  end

  after :all do
    @browser.close
  end
end

