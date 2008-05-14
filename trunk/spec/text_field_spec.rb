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
  
  # Exist method
  describe "#exists?" do
    it "should return true if the element exists" do
      @ie.text_field(:id, 'new_user_email').should exist
      @ie.text_field(:id, /new_user_email/).should exist
      @ie.text_field(:name, 'new_user_email').should exist
      @ie.text_field(:name, /new_user_email/).should exist
      @ie.text_field(:value, 'Developer').should exist
      @ie.text_field(:value, /Developer/).should exist
      @ie.text_field(:text, 'Developer').should exist
      @ie.text_field(:text, /Developer/).should exist
      @ie.text_field(:class, 'name').should exist
      @ie.text_field(:class, /name/).should exist
      @ie.text_field(:index, 1).should exist
      @ie.text_field(:xpath, "//input[@id='new_user_email']").should exist
     end

    it "should return true if the element exists (no type attribute)" do
      @ie.text_field(:id, 'new_user_first_name').should exist
    end

    it "should return true if the element exists (invalid type attribute)" do
      @ie.text_field(:id, 'new_user_last_name').should exist
    end

    it "should return false if the element does not exist" do
      @ie.text_field(:id, 'no_such_id').should_not exist
      @ie.text_field(:id, /no_such_id/).should_not exist
      @ie.text_field(:name, 'no_such_name').should_not exist
      @ie.text_field(:name, /no_such_name/).should_not exist
      @ie.text_field(:value, 'no_such_value').should_not exist
      @ie.text_field(:value, /no_such_value/).should_not exist
      @ie.text_field(:text, 'no_such_text').should_not exist
      @ie.text_field(:text, /no_such_text/).should_not exist
      @ie.text_field(:class, 'no_such_class').should_not exist
      @ie.text_field(:class, /no_such_class/).should_not exist
      @ie.text_field(:index, 1337).should_not exist
      @ie.text_field(:xpath, "//input[@id='no_such_id']").should_not exist
    end

    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @ie.text_field(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end

    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @ie.text_field(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  
  # Attribute methods
  describe "#id" do
    it "should return the id attribute if the text field exists" do
      @ie.text_field(:index, 4).id.should == "new_user_occupation"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.text_field(:index, 1337).id }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#name" do
    it "should return the name attribute if the text field exists" do
      @ie.text_field(:index, 4).name.should == "new_user_occupation"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.text_field(:index, 1337).name }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#title" do
    it "should return the title attribute if the text field exists" do
      @ie.text_field(:id, "new_user_code").title.should == "Your personal code"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.text_field(:index, 1337).title }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#type" do
    #TODO: What if the type attribute is non-existent or invalid?
    it "should return the type attribute if the text field exists" do
      @ie.text_field(:index, 4).type.should == "text"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.text_field(:index, 1337).type }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#value" do
    it "should return the value attribute if the text field exists" do
      @ie.text_field(:name, "new_user_occupation").value.should == "Developer"
      @ie.text_field(:index, 4).value.should == "Developer"
      @ie.text_field(:name, /new_user_occupation/i).value.should == "Developer"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.text_field(:index, 1337).value }.should raise_error(UnknownObjectException)  
    end
  end

  # Access methods
  describe "#enabled?" do
    it "should return true for enabled text fields" do
      @ie.text_field(:name, "new_user_occupation").should be_enabled
      @ie.text_field(:id, "new_user_email").should be_enabled
    end
    it "should return false for disabled text fields" do
      @ie.text_field(:name, "new_user_species").should_not be_enabled
    end
  end
  
  describe "#disabled?" do
    it "should return true if the text field is disabled" do
      @ie.text_field(:id, 'new_user_species').should be_disabled
    end
    it "should return false if the text field is enabled" do
      @ie.text_field(:index, 1).should_not be_disabled
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.text_field(:index, 1337).disabled? }.should raise_error(UnknownObjectException)  
    end
  end

  describe "#readonly?" do
    it "should return true for read-only text fields" do
      @ie.text_field(:name, "new_user_code").should be_readonly
      @ie.text_field(:id, "new_user_code").should be_readonly
    end
    it "should return false for writeable text fields" do
      @ie.text_field(:name, "new_user_email").should_not be_readonly
    end
  end
  
  
  # Manipulation methods
  
  describe "#append" do
    it "should append the text to the text field" do
      @ie.text_field(:name, "new_user_occupation").append(" Append This")
      @ie.text_field(:name, "new_user_occupation").get_contents.should == "Developer Append This"
    end
    it "should append multi-byte characters" do
      @ie.text_field(:name, "new_user_occupation").append(" ĳĳ")
      @ie.text_field(:name, "new_user_occupation").get_contents.should == "Developer ĳĳ"
    end
    it "should raise ObjectReadOnlyException if the object is read only" do
      lambda { @ie.text_field(:id, "new_user_code").append("Append This") }.should raise_error(ObjectReadOnlyException)  
    end
    it "should raise ObjectDisabledException if the object is disabled" do
      lambda { @ie.text_field(:name, "new_user_species").append("Append This") }.should raise_error(ObjectDisabledException)  
    end
    it "should raise UnknownObjectException if the object doesn't exist" do
      lambda { @ie.text_field(:name, "no_such_name").append("Append This") }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#clear" do
    it "should remove all text from the text field" do
      @ie.text_field(:name, "new_user_occupation").clear
      @ie.text_field(:name, "new_user_occupation").get_contents.should be_empty
      @ie.text_field(:id, "delete_user_comment").clear
      @ie.text_field(:id, "delete_user_comment").get_contents.should be_empty
    end
  end
  
  describe "#drag_contents_to" do
    it "should drag contents to another text field" do
      @ie.text_field(:name, "new_user_first_name").set("Smith")
      @ie.text_field(:name, "new_user_first_name").drag_contents_to(:name, "new_user_last_name")
      @ie.text_field(:name, "new_user_first_name").value.should be_empty
      @ie.text_field(:id, "new_user_last_name").value.should == "Smith"
    end
  end
  
  describe "#get_contents" do
    it "should raise UnknownObjectException when accessing a non-existing element" do
      lambda { @ie.text_field(:name, "no_such_name").get_contents }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#value=" do
    it "should set the value of the element" do
      @ie.text_field(:id, 'new_user_email').value = 'Hello Cruel World'
      @ie.text_field(:id, "new_user_email").value.should == 'Hello Cruel World'
    end
    
    it "should be able to set multi-byte characters" do
      @ie.text_field(:name, "new_user_occupation").value = "ĳĳ"
      @ie.text_field(:name, "new_user_occupation").get_contents.should == "ĳĳ"
    end
    
    it "should set the value of a textarea element" do
      @ie.text_field(:id, 'delete_user_comment').value = 'Hello Cruel World'
      @ie.text_field(:id, "delete_user_comment").value.should == 'Hello Cruel World'
    end
  end

  describe "#set" do
    it "should set the value of the element" do
      @ie.text_field(:id, 'new_user_email').set('Bye Cruel World')
      @ie.text_field(:id, "new_user_email").value.should == 'Bye Cruel World'
    end
    
    it "should set the value of a textarea element" do
      @ie.text_field(:id, 'delete_user_comment').set('Hello Cruel World')
      @ie.text_field(:id, "delete_user_comment").value.should == 'Hello Cruel World'
    end
    
    it "should fire events"
    
    it "should be able to set the value of a password field" do
      @ie.text_field(:name , 'new_user_password').set('secret')
      @ie.text_field(:name , 'new_user_password').value.should == 'secret'
    end
    it "should be able to set multi-byte characters" do
      @ie.text_field(:name, "new_user_occupation").set("ĳĳ")
      @ie.text_field(:name, "new_user_occupation").get_contents.should == "ĳĳ"
    end
  end

  describe "#verify_contains" do
    it "should verify that a text field contains its value" do
      @ie.text_field(:name, "new_user_occupation").verify_contains("Developer").should be_true
      @ie.text_field(:name, "new_user_occupation").verify_contains(/Developer/).should be_true
    end
    it "should not verify that a text field contains a non-existing value" do
      @ie.text_field(:name, "new_user_email").verify_contains("no_such_text").should be_false
      @ie.text_field(:name, "new_user_email").verify_contains(/no_such_text/).should be_false
    end
  end

  after :all do
    @ie.close
  end
end

