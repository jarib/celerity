require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Radio" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end

  
  # Exists method
  
  describe "#exists?" do
    it "should return true if the radio button exists" do
      @ie.radio(:id, "new_user_newsletter_yes").should exist
      @ie.radio(:id, /new_user_newsletter_yes/).should exist
      @ie.radio(:name, "new_user_newsletter").should exist
      @ie.radio(:name, /new_user_newsletter/).should exist
      @ie.radio(:value, "yes").should exist
      @ie.radio(:value, /yes/).should exist
      # we need to figure out what :text means for a radio button
      @ie.radio(:text, "yes").should exist
      @ie.radio(:text, /yes/).should exist
      @ie.radio(:class, "huge").should exist
      @ie.radio(:class, /huge/).should exist
      @ie.radio(:index, 1).should exist
      @ie.radio(:xpath, "input[@id='new_user_newsletter_yes']").should exist
    end
    
    it "should return true if the radio button exists (search by name and value)" do
      @ie.radio(:name, "new_user_newsletter", 'yes').should exist
      @ie.radio(:xpath, "//input[@name='new_user_newsletter' and @value='yes']").set
    end
    
    it "should return false if the radio button does not exist" do
      @ie.radio(:id, "no_such_id").should_not exist
      @ie.radio(:id, /no_such_id/).should_not exist
      @ie.radio(:name, "no_such_name").should_not exist
      @ie.radio(:name, /no_such_name/).should_not exist
      @ie.radio(:value, "no_such_value").should_not exist
      @ie.radio(:value, /no_such_value/).should_not exist
      @ie.radio(:text, "no_such_text").should_not exist
      @ie.radio(:text, /no_such_text/).should_not exist
      @ie.radio(:class, "no_such_class").should_not exist
      @ie.radio(:class, /no_such_class/).should_not exist
      @ie.radio(:index, 1337).should_not exist
      @ie.radio(:xpath, "input[@id='no_such_id']").should_not exist
    end
    
    it "should return false if the radio button does not exist (search by name and value)" do
      @ie.radio(:name, "new_user_newsletter", 'no_such_value').should_not exist
      @ie.radio(:xpath, "//input[@name='new_user_newsletter' and @value='no_such_value']").should_not exist
      @ie.radio(:name, "no_such_name", 'yes').should_not exist
      @ie.radio(:xpath, "//input[@name='no_such_name' and @value='yes']").should_not exist
    end
    
    it "should return true for radios with a string value" do
      @ie.radio(:name, 'new_user_newsletter', 'yes').should exist
      @ie.radio(:name, 'new_user_newsletter', 'no').should exist
    end
    
    it "should raise ArgumentError when what argument is invalid" do
      lambda { @ie.radio(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end

    it "should raise MissingWayOfFindingObjectException when how argument is invalid" do
      lambda { @ie.radio(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  
  # Attribute methods
  
  describe "#class_name" do
    it "should return the class name if the radio exists and has an attribute" do
      @ie.radio(:id, "new_user_newsletter_yes").class_name.should == "huge"
    end
    it "should return an emptry string if the radio exists and the attribute doesn't" do
      @ie.radio(:id, "new_user_newsletter_no").class_name.should == ""
    end
    it "should raise UnknownObjectException if the radio doesn't exist" do
      lambda { @ie.radio(:id, "no_such_id").class_name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#id" do
    it "should return the id attribute if the radio exists and has an attribute" do
      @ie.radio(:index, 1).id.should == "new_user_newsletter_yes"
    end
    it "should return an emptry string if the radio exists and the attribute doesn't" do
      @ie.radio(:index, 3).id.should == ""
    end
    it "should raise UnknownObjectException if the radio doesn't exist" do
      lambda { @ie.radio(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end

  describe "#name" do
    it "should return the name attribute if the radio exists" do
      @ie.radio(:id, 'new_user_newsletter_yes').name.should == "new_user_newsletter"
    end
    it "should return an empty string if the radio exists and the attribute doesn't" do
      @ie.radio(:id, 'new_user_newsletter_absolutely').name.should == ""
    end
    it "should raise UnknownObjectException if the radio doesn't exist" do
      lambda { @ie.radio(:index, 1337).name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#title" do
    it "should return the title attribute if the radio exists" do
      @ie.radio(:id, "new_user_newsletter_no").title.should == "Traitor!"
    end
    it "should return an emptry string if the radio exists and the attribute doesn't" do
      @ie.radio(:id, "new_user_newsletter_yes").title.should == ""
    end
    it "should raise UnknownObjectException if the radio doesn't exist" do
      lambda { @ie.radio(:index, 1337).title }.should raise_error(UnknownObjectException)  
    end
  end

  describe "#type" do
    it "should return the type attribute if the radio exists" do
      @ie.radio(:index, 1).type.should == "radio"
    end
    it "should raise UnknownObjectException if the radio doesn't exist" do
      lambda { @ie.radio(:index, 1337).type }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#value" do
    it "should return the value attribute if the radio exists" do
      @ie.radio(:id, 'new_user_newsletter_yes').value.should == 'yes'
    end
    it "should raise UnknownObjectException if the radio doesn't exist" do
      lambda { @ie.radio(:index, 1337).value}.should raise_error(UnknownObjectException)
    end
  end
  
  
  # Access methods
  
  describe "#enabled?" do
    it "should return true if the radio button is enabled" do
      @ie.radio(:id, "new_user_newsletter_yes").should be_enabled
      @ie.radio(:xpath, "//input[@id='new_user_newsletter_yes']").should be_enabled
    end
    it "should return false if the radio button is disabled" do
      @ie.radio(:id, "new_user_newsletter_nah").should_not be_enabled
      @ie.radio(:xpath,"//input[@id='new_user_newsletter_nah']").should_not be_enabled
    end
    it "should raise UnknownObjectException if the radio button doesn't exist" do
      lambda { @ie.radio(:id, "no_such_id").enabled?  }.should raise_error(UnknownObjectException)  
      lambda { @ie.radio(:xpath, "//input[@id='no_such_id']").enabled?  }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#disabled?" do
    it "should return true if the radio is disabled" do
      @ie.radio(:id, 'new_user_newsletter_nah').should be_disabled
    end
    it "should return false if the radio is enabled" do
      @ie.radio(:id, 'new_user_newsletter_yes').should_not be_disabled
    end
    it "should raise UnknownObjectException if the radio doesn't exist" do
      lambda { @ie.radio(:index, 1337).disabled? }.should raise_error(UnknownObjectException)  
    end
  end
  
  
  # Manipulation methods
  
  describe "clear" do
    it "should clear the radio button if it is set" do
      @ie.radio(:id, "new_user_newsletter_yes").clear
      @ie.radio(:id, "new_user_newsletter_yes").should_not be_set
    end
    it "should clear the radio button when found by :xpath" do
      @ie.radio(:xpath, "//input[@id='new_user_newsletter_yes']").clear
      @ie.radio(:xpath, "//input[@id='new_user_newsletter_yes']").should_not be_set
    end
    it "should raise UnknownObjectException if the radio button doesn't exist" do
      lambda { @ie.radio(:name, "no_such_id").clear }.should raise_error(UnknownObjectException)
      lambda { @ie.radio(:xpath, "//input[@id='no_such_id']").clear  }.should raise_error(UnknownObjectException)  
    end
    it "should raise ObjectDisabledException if the radio is disabled" do
      @ie.radio(:id, "new_user_newsletter_nah").should_not be_set
      lambda { @ie.radio(:id, "new_user_newsletter_nah").clear }.should raise_error(ObjectDisabledException)
      lambda { @ie.radio(:xpath, "//input[@id='new_user_newsletter_nah']").clear }.should raise_error(ObjectDisabledException)
    end
  end
  
  describe "#set" do
    it "should set the radio button" do
      @ie.radio(:id, "new_user_newsletter_no").set
      @ie.radio(:id, "new_user_newsletter_no").should be_set
    end
    it "should set the radio button when found by :xpath" do
      @ie.radio(:xpath, "//input[@id='new_user_newsletter_no']").set
      @ie.radio(:xpath, "//input[@id='new_user_newsletter_no']").should be_set
    end

    it "should fire the onclick event"

    it "should raise UnknownObjectException if the radio button doesn't exist" do
      lambda { @ie.radio(:name, "no_such_name").set  }.should raise_error(UnknownObjectException)
      lambda { @ie.radio(:xpath, "//input[@name='no_such_name']").set  }.should raise_error(UnknownObjectException)
    end
    it "should raise ObjectDisabledException if the radio is disabled" do
      lambda { @ie.radio(:id, "new_user_newsletter_nah").set  }.should raise_error(ObjectDisabledException)
      lambda { @ie.radio(:xpath, "//input[@id='new_user_newsletter_nah']").set  }.should raise_error(ObjectDisabledException )
    end
  end
  
  
  # Other
  
  describe '#set?' do
    it "should return true if the radio button is set" do
      @ie.radio(:id, "new_user_newsletter_yes").should be_set
    end
    it "should return false if the radio button unset" do
      @ie.radio(:id, "new_user_newsletter_no").should_not be_set
    end
    it "should return the state for radios with string values" do
      @ie.radio(:name, "new_user_newsletter", 'no').should_not be_set
      @ie.radio(:name, "new_user_newsletter", 'no').set
      @ie.radio(:name, "new_user_newsletter", 'no').should be_set
      @ie.radio(:name, "new_user_newsletter", 'no').clear
      @ie.radio(:name, "new_user_newsletter", 'no').should_not be_set
    end
    it "should raise UnknownObjectException if the radio button doesn't exist" do
      lambda { @ie.radio(:id, "no_such_id").set?  }.should raise_error(UnknownObjectException)  
      lambda { @ie.radio(:xpath, "//input[@id='no_such_id']").set?  }.should raise_error(UnknownObjectException)
    end    
  end
  
  describe "#get_state" do
    it "should return true if the radio is set" do
      @ie.radio(:id, "new_user_newsletter_yes").get_state.should be_true
    end
    it "should return false if the radio is unset" do
      @ie.radio(:id, "new_user_newsletter_no").get_state.should be_false
    end
    it "should raise UnknownObjectException if the radio doesn't exist" do
      lambda {   @ie.radio(:name, "no_such_name").get_state  }.should raise_error(UnknownObjectException)
      lambda {   @ie.radio(:xpath, "//input[@name='no_such_name']").get_state  }.should raise_error(UnknownObjectException)
    end
  end

  after :all do
    @ie.close
  end

end

