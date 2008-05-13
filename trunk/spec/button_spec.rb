require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Button" do

  before :all do
    @ie = IE.new
    add_spec_checker(@ie)
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  # Exists method
  describe "#exists?" do
    it "should return true if the button exists" do
      @ie.button(:id, "new_user_submit").should exist
      @ie.button(:id, /new_user_submit/).should exist
      @ie.button(:name, "new_user_reset").should exist
      @ie.button(:name, /new_user_reset/).should exist
      # we need to figure out what :text and :value/:caption means on input type="button" and <button /> elements
      # it should return the value attribute for <input> elements, and the inner text for <button> elements - Jari 2008-05-10
      @ie.button(:value, "Button 2").should exist
      @ie.button(:value, /Button 2/).should exist
      @ie.button(:text, "Button 2").should exist
      @ie.button(:text, /Button 2/).should exist
      @ie.button(:class, "image").should exist
      @ie.button(:class, /image/).should exist
      @ie.button(:index, 1).should exist
      @ie.button(:xpath, "//input[@id='new_user_submit']").should exist
    end
    
    it "should return true if the button exists (how = :caption)" do
      # we need to figure out what :text and :value/:caption means on input type="button" and <button /> elements
      @ie.button(:caption, "Button 2").should exist
      @ie.button(:caption, /Button 2/).should exist
    end
    
    it "should return true if the button exists (default how = :value)" do
      @ie.button("Submit").should exist
    end
    
    it "should return false if the button doesn't exist" do
      @ie.button(:id, "no_such_id").should_not exist
      @ie.button(:id, /no_such_id/).should_not exist
      @ie.button(:name, "no_such_name").should_not exist
      @ie.button(:name, /no_such_name/).should_not exist
      # we need to figure out what :text and :value/:caption means on input type="button" and <button /> elements
      @ie.button(:value, "no_such_value").should_not exist
      @ie.button(:value, /no_such_value/).should_not exist
      @ie.button(:text, "no_such_text").should_not exist
      @ie.button(:text, /no_such_text/).should_not exist
      @ie.button(:class, "no_such_class").should_not exist
      @ie.button(:class, /no_such_class/).should_not exist
      @ie.button(:index, 1337).should_not exist
      @ie.button(:xpath, "//input[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @ie.button(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @ie.button(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#class_name" do
    it "should return the class name of the button" do
      @ie.button(:name, "new_user_image").class_name.should == "image"
    end
    it "should return an empty string if the button has no class name" do
      @ie.button(:name, "new_user_submit").class_name.should == ""
    end
  end
  
  describe "#id" do
    it "should return the id if the button exists" do
      @ie.button(:index, 1).id.should == 'new_user_submit'
      @ie.button(:index, 2).id.should == 'new_user_reset'
      @ie.button(:index, 3).id.should == 'new_user_button'
    end
    it "should raise UnknownObjectException if button does not exist" do
      lambda { @ie.button(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end

  describe "#name" do
    it "should return the name if button exists" do
      @ie.button(:index, 1).name.should == 'new_user_submit'
      @ie.button(:index, 2).name.should == 'new_user_reset'
      @ie.button(:index, 3).name.should == 'new_user_button'
    end
    it "should raise UnknownObjectException if button does not exist" do
      lambda { @ie.button(:name, "no_such_name").name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#title" do
    it "should return the title of the button" do
      @ie.button(:index, 1).title.should == 'Submit the form'
    end
    it "should return an empty string for button without title" do
      @ie.button(:index, 2).title.should == ''
    end
  end

  describe "#type" do
    it "should return the type if button exists" do
      @ie.button(:index, 1).type.should == 'submit'
      @ie.button(:index, 2).type.should == 'reset'
      @ie.button(:index, 3).type.should == 'button'
    end
    it "should raise UnknownObjectException if button does not exist" do
      lambda { @ie.button(:name, "no_such_name").type }.should raise_error(UnknownObjectException)
    end
  end

  describe "#value" do
    it "should return the value if button exists" do
      @ie.button(:index, 1).value.should == 'Submit'
      @ie.button(:index, 2).value.should == 'Reset'
      @ie.button(:index, 3).value.should == 'Button'
    end
    it "should raise UnknownObjectException if button does not exist" do
      lambda { @ie.button(:name, "no_such_name").value }.should raise_error(UnknownObjectException)
    end
  end

  # Access methods
  describe "#enabled?" do
    it "should return true if the button is enabled" do
      @ie.button(:name, 'new_user_submit').should be_enabled
    end
    it "should return false if the button is disabled" do
      @ie.button(:name, 'new_user_submit_disabled').should_not be_enabled
    end
    it "should raise UnknownObjectException if the button doesn't exist" do
      lambda { @ie.button(:name, "no_such_name").enabled? }.should raise_error(UnknownObjectException)
    end
  end

  describe "#disabled?" do
    it "should return false when button is enabled" do
      @ie.button(:name, 'new_user_submit').should_not be_disabled
    end
    it "should return true when button is disabled" do
      @ie.button(:name, 'new_user_submit_disabled').should be_disabled
    end
    it "should raise UnknownObjectException if button does not exist" do
      lambda { @ie.button(:name, "no_such_name").disabled? }.should raise_error(UnknownObjectException)
    end
  end
  
  # Manipulation methods
  describe "#click" do
    it "should click the button if it exists" do
      pending
    end
    it "should fire events" do
      @ie.button(:id, 'new_user_button').click
      @ie.button(:id, 'new_user_button').value.should == 'new_value_set_by_onclick_event'
    end
    it "should raise UnknownObjectException when clicking a button that doesn't exist" do
      lambda { @ie.button(:value, "no_such_value").click }.should raise_error(UnknownObjectException)
      lambda { @ie.button(:id, "no_such_id").click }.should raise_error(UnknownObjectException)
    end
    it "should raise ObjectDisabledException when clicking a disabled button" do
      lambda { @ie.button(:value, "Disabled").click }.should raise_error(ObjectDisabledException)
    end
  end

  after :all do
    @ie.close
  end
end
