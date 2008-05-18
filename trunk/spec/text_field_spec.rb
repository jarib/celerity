require File.dirname(__FILE__) + '/spec_helper.rb'

describe TextField do
  
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
      @browser.text_field(:id, 'new_user_email').should exist
      @browser.text_field(:id, /new_user_email/).should exist
      @browser.text_field(:name, 'new_user_email').should exist
      @browser.text_field(:name, /new_user_email/).should exist
      @browser.text_field(:value, 'Developer').should exist
      @browser.text_field(:value, /Developer/).should exist
      @browser.text_field(:text, 'Developer').should exist
      @browser.text_field(:text, /Developer/).should exist
      @browser.text_field(:class, 'name').should exist
      @browser.text_field(:class, /name/).should exist
      @browser.text_field(:index, 1).should exist
      @browser.text_field(:xpath, "//input[@id='new_user_email']").should exist
     end

    it "should return true if the element exists (no type attribute)" do
      @browser.text_field(:id, 'new_user_first_name').should exist
    end

    it "should return true if the element exists (invalid type attribute)" do
      @browser.text_field(:id, 'new_user_last_name').should exist
    end

    it "should return false if the element does not exist" do
      @browser.text_field(:id, 'no_such_id').should_not exist
      @browser.text_field(:id, /no_such_id/).should_not exist
      @browser.text_field(:name, 'no_such_name').should_not exist
      @browser.text_field(:name, /no_such_name/).should_not exist
      @browser.text_field(:value, 'no_such_value').should_not exist
      @browser.text_field(:value, /no_such_value/).should_not exist
      @browser.text_field(:text, 'no_such_text').should_not exist
      @browser.text_field(:text, /no_such_text/).should_not exist
      @browser.text_field(:class, 'no_such_class').should_not exist
      @browser.text_field(:class, /no_such_class/).should_not exist
      @browser.text_field(:index, 1337).should_not exist
      @browser.text_field(:xpath, "//input[@id='no_such_id']").should_not exist
    end

    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.text_field(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end

    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.text_field(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  
  # Attribute methods
  describe "#id" do
    it "should return the id attribute if the text field exists" do
      @browser.text_field(:index, 4).id.should == "new_user_occupation"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @browser.text_field(:index, 1337).id }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#name" do
    it "should return the name attribute if the text field exists" do
      @browser.text_field(:index, 4).name.should == "new_user_occupation"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @browser.text_field(:index, 1337).name }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#title" do
    it "should return the title attribute if the text field exists" do
      @browser.text_field(:id, "new_user_code").title.should == "Your personal code"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @browser.text_field(:index, 1337).title }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#type" do
    #TODO: What if the type attribute is non-existent or invalid?
    # Should probably just return the empty string, like HtmlUnit? (Jari - 2008-05-16)
    it "should return the type attribute if the text field exists" do
      @browser.text_field(:index, 4).type.should == "text"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @browser.text_field(:index, 1337).type }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#value" do
    it "should return the value attribute if the text field exists" do
      @browser.text_field(:name, "new_user_occupation").value.should == "Developer"
      @browser.text_field(:index, 4).value.should == "Developer"
      @browser.text_field(:name, /new_user_occupation/i).value.should == "Developer"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @browser.text_field(:index, 1337).value }.should raise_error(UnknownObjectException)  
    end
  end

  # Access methods
  describe "#enabled?" do
    it "should return true for enabled text fields" do
      @browser.text_field(:name, "new_user_occupation").should be_enabled
      @browser.text_field(:id, "new_user_email").should be_enabled
    end
    it "should return false for disabled text fields" do
      @browser.text_field(:name, "new_user_species").should_not be_enabled
    end
    it "should raise UnknownObjectException if the text field doesn't exist"
  end
  
  describe "#disabled?" do
    it "should return true if the text field is disabled" do
      @browser.text_field(:id, 'new_user_species').should be_disabled
    end
    it "should return false if the text field is enabled" do
      @browser.text_field(:index, 1).should_not be_disabled
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @browser.text_field(:index, 1337).disabled? }.should raise_error(UnknownObjectException)  
    end
  end

  describe "#readonly?" do
    it "should return true for read-only text fields" do
      @browser.text_field(:name, "new_user_code").should be_readonly
      @browser.text_field(:id, "new_user_code").should be_readonly
    end
    it "should return false for writeable text fields" do
      @browser.text_field(:name, "new_user_email").should_not be_readonly
    end
    it "should raise UnknownObjectException if the text field doesn't exist"
  end
  
  
  # Manipulation methods
  
  describe "#append" do
    it "should append the text to the text field" do
      @browser.text_field(:name, "new_user_occupation").append(" Append This")
      @browser.text_field(:name, "new_user_occupation").get_contents.should == "Developer Append This"
    end
    it "should append multi-byte characters" do
      @browser.text_field(:name, "new_user_occupation").append(" ĳĳ")
      @browser.text_field(:name, "new_user_occupation").get_contents.should == "Developer ĳĳ"
    end
    it "should raise ObjectReadOnlyException if the object is read only" do
      lambda { @browser.text_field(:id, "new_user_code").append("Append This") }.should raise_error(ObjectReadOnlyException)  
    end
    it "should raise ObjectDisabledException if the object is disabled" do
      lambda { @browser.text_field(:name, "new_user_species").append("Append This") }.should raise_error(ObjectDisabledException)  
    end
    it "should raise UnknownObjectException if the object doesn't exist" do
      lambda { @browser.text_field(:name, "no_such_name").append("Append This") }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#clear" do
    it "should remove all text from the text field" do
      @browser.text_field(:name, "new_user_occupation").clear
      @browser.text_field(:name, "new_user_occupation").get_contents.should be_empty
      @browser.text_field(:id, "delete_user_comment").clear
      @browser.text_field(:id, "delete_user_comment").get_contents.should be_empty
    end
    it "should raise UnknownObjectException if the text field doesn't exist"
  end
  
  describe "#drag_contents_to" do
    it "should drag contents to another text field" do
      @browser.text_field(:name, "new_user_first_name").set("Smith")
      @browser.text_field(:name, "new_user_first_name").drag_contents_to(:name, "new_user_last_name")
      @browser.text_field(:name, "new_user_first_name").value.should be_empty
      @browser.text_field(:id, "new_user_last_name").value.should == "Smith"
    end
    it "should raise UnknownObjectException if either of the text fields doesn't exist"
  end
  
  describe "#get_contents" do
    it "should raise UnknownObjectException when accessing a non-existing element" do
      lambda { @browser.text_field(:name, "no_such_name").get_contents }.should raise_error(UnknownObjectException)
    end
    
    it "should raise UnknownObjectException if the text field doesn't exist"
  end
  
  describe "#value=" do
    it "should set the value of the element" do
      @browser.text_field(:id, 'new_user_email').value = 'Hello Cruel World'
      @browser.text_field(:id, "new_user_email").value.should == 'Hello Cruel World'
    end
    
    it "should be able to set multi-byte characters" do
      @browser.text_field(:name, "new_user_occupation").value = "ĳĳ"
      @browser.text_field(:name, "new_user_occupation").get_contents.should == "ĳĳ"
    end
    
    it "should set the value of a textarea element" do
      @browser.text_field(:id, 'delete_user_comment').value = 'Hello Cruel World'
      @browser.text_field(:id, "delete_user_comment").value.should == 'Hello Cruel World'
    end
    
    it "should raise UnknownObjectException if the text field doesn't exist"
  end

  describe "#set" do
    it "should set the value of the element" do
      @browser.text_field(:id, 'new_user_email').set('Bye Cruel World')
      @browser.text_field(:id, "new_user_email").value.should == 'Bye Cruel World'
    end
    
    it "should set the value of a textarea element" do
      @browser.text_field(:id, 'delete_user_comment').set('Hello Cruel World')
      @browser.text_field(:id, "delete_user_comment").value.should == 'Hello Cruel World'
    end
    
    it "should fire events" do
      @browser.text_field(:id, "new_user_username").set("Hello World")
      @browser.span(:id, "current_length").text.should == "11"
    end
    
    it "should be able to set the value of a password field" do
      @browser.text_field(:name , 'new_user_password').set('secret')
      @browser.text_field(:name , 'new_user_password').value.should == 'secret'
    end
    it "should be able to set multi-byte characters" do
      @browser.text_field(:name, "new_user_occupation").set("ĳĳ")
      @browser.text_field(:name, "new_user_occupation").get_contents.should == "ĳĳ"
    end
    
    it "should raise UnknownObjectException if the text field doesn't exist"
  end

  describe "#verify_contains" do
    it "should verify that a text field contains its value" do
      @browser.text_field(:name, "new_user_occupation").verify_contains("Developer").should be_true
      @browser.text_field(:name, "new_user_occupation").verify_contains(/Developer/).should be_true
    end
    it "should not verify that a text field contains a non-existing value" do
      @browser.text_field(:name, "new_user_email").verify_contains("no_such_text").should be_false
      @browser.text_field(:name, "new_user_email").verify_contains(/no_such_text/).should be_false
    end
    
    it "should raise UnknownObjectException if the text field doesn't exist"
  end

  after :all do
    @browser.close
  end
end

