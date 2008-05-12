require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Checkbox" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  
  # Exists method
  
  describe "#exists?" do
    it "should return true if the checkbox button exists" do
      @ie.checkbox(:id, "new_user_interests_books").should exist
      @ie.checkbox(:id, /new_user_interests_books/).should exist
      @ie.checkbox(:name, "new_user_interests").should exist
      @ie.checkbox(:name, /new_user_interests/).should exist
      @ie.checkbox(:value, "books").should exist
      @ie.checkbox(:value, /books/).should exist
      # unsure what :text is supposed to represent here
      # @ie.checkbox(:text, "books").should exist
      # @ie.checkbox(:text, /books/).should exist
      @ie.checkbox(:class, "fun").should exist
      @ie.checkbox(:class, /fun/).should exist
      @ie.checkbox(:index, 1).should exist
      @ie.checkbox(:xpath, "//input[@id='new_user_interests_books']").should exist
    end
    
    it "should return true if the checkbox button exists (search by name and value)" do
      @ie.checkbox(:name, "new_user_interests", 'cars').should exist
      @ie.checkbox(:xpath, "//input[@name='new_user_interests' and @value='cars']").set
    end
    
    it "should return false if the checkbox button does not exist" do
      @ie.checkbox(:id, "no_such_id").should_not exist
      @ie.checkbox(:id, /no_such_id/).should_not exist
      @ie.checkbox(:name, "no_such_name").should_not exist
      @ie.checkbox(:name, /no_such_name/).should_not exist
      @ie.checkbox(:value, "no_such_value").should_not exist
      @ie.checkbox(:value, /no_such_value/).should_not exist
      @ie.checkbox(:text, "no_such_text").should_not exist
      @ie.checkbox(:text, /no_such_text/).should_not exist
      @ie.checkbox(:class, "no_such_class").should_not exist
      @ie.checkbox(:class, /no_such_class/).should_not exist
      @ie.checkbox(:index, 1337).should_not exist
      @ie.checkbox(:xpath, "//input[@id='no_such_id']").should_not exist
    end
    
    it "should return false if the checkbox button does not exist (search by name and value)" do
      @ie.checkbox(:name, "new_user_interests", 'no_such_value').should_not exist
      @ie.checkbox(:xpath, "//input[@name='new_user_interests' and @value='no_such_value']").should_not exist
      @ie.checkbox(:name, "no_such_name", 'cars').should_not exist
      @ie.checkbox(:xpath, "//input[@name='no_such_name' and @value='cars']").should_not exist
    end
    
    it "should return true for checkboxs with a string value" do
      @ie.checkbox(:name, 'new_user_interests', 'books').should exist
      @ie.checkbox(:name, 'new_user_interests', 'cars').should exist
    end
    
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @ie.checkbox(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end

    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @ie.checkbox(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  
  # Attribute methods
  
  describe "#class_name" do
    it "should return the class name if the checkbox exists and has an attribute" do
      @ie.checkbox(:id, "new_user_interests_dancing").class_name.should == "fun"
    end
    it "should return an emptry string if the checkbox exists and the attribute doesn't" do
      @ie.checkbox(:id, "new_user_interests_books").class_name.should == ""
    end
    it "should raise UnknownObjectException if the checkbox doesn't exist" do
      lambda { @ie.checkbox(:id, "no_such_id").class_name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#id" do
    it "should return the id attribute if the checkbox exists and has an attribute" do
      @ie.checkbox(:index, 1).id.should == "new_user_interests_books"
    end
    it "should return an emptry string if the checkbox exists and the attribute doesn't" do
      @ie.checkbox(:index, 2).id.should == ""
    end
    it "should raise UnknownObjectException if the checkbox doesn't exist" do
      lambda { @ie.checkbox(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end

  describe "#name" do
    it "should return the name attribute if the checkbox exists" do
      @ie.checkbox(:id, 'new_user_interests_books').name.should == "new_user_interests"
    end
    it "should return an empty string if the checkbox exists and the attribute doesn't" do
      @ie.checkbox(:id, 'new_user_interests_food').name.should == ""
    end
    it "should raise UnknownObjectException if the checkbox doesn't exist" do
      lambda { @ie.checkbox(:index, 1337).name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#title" do
    it "should return the title attribute if the checkbox exists" do
      @ie.checkbox(:id, "new_user_interests_dancing").title.should == "Dancing is fun!"
    end
    it "should return an emptry string if the checkbox exists and the attribute doesn't" do
      @ie.checkbox(:id, "new_user_interests_books").title.should == ""
    end
    it "should raise UnknownObjectException if the checkbox doesn't exist" do
      lambda { @ie.checkbox(:index, 1337).title }.should raise_error(UnknownObjectException)  
    end
  end

  describe "#type" do
    it "should return the type attribute if the checkbox exists" do
      @ie.checkbox(:index, 1).type.should == "checkbox"
    end
    it "should raise UnknownObjectException if the checkbox doesn't exist" do
      lambda { @ie.checkbox(:index, 1337).type }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#value" do
    it "should return the value attribute if the checkbox exists" do
      @ie.checkbox(:id, 'new_user_interests_books').value.should == 'books'
    end
    it "should raise UnknownObjectException if the checkbox doesn't exist" do
      lambda { @ie.checkbox(:index, 1337).value}.should raise_error(UnknownObjectException)  
    end
  end
  
  
  # Access methods
  
  describe "#enabled?" do
    it "should return true if the checkbox button is enabled" do
      @ie.checkbox(:id, "new_user_interests_books").should be_enabled
      @ie.checkbox(:xpath, "//input[@id='new_user_interests_books']").should be_enabled
    end
    it "should return false if the checkbox button is disabled" do
      @ie.checkbox(:id, "new_user_interests_dentistry").should_not be_enabled
      @ie.checkbox(:xpath,"//input[@id='new_user_interests_dentistry']").should_not be_enabled
    end
    it "should raise UnknownObjectException if the checkbox button doesn't exist" do
      lambda { @ie.checkbox(:id, "no_such_id").enabled?  }.should raise_error(UnknownObjectException)  
      lambda { @ie.checkbox(:xpath, "//input[@id='no_such_id']").enabled?  }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#disabled?" do
    it "should return true if the checkbox is disabled" do
      @ie.checkbox(:id, 'new_user_interests_dentistry').should be_disabled
    end
    it "should return false if the checkbox is enabled" do
      @ie.checkbox(:id, 'new_user_interests_books').should_not be_disabled
    end
    it "should raise UnknownObjectException if the checkbox doesn't exist" do
      lambda { @ie.checkbox(:index, 1337).disabled? }.should raise_error(UnknownObjectException)  
    end
  end
  
  
  # Manipulation methods
  
  describe "#clear" do
    it "should raise ObjectDisabledException if the checkbox is disabled" do
      @ie.checkbox(:id, "new_user_interests_dentistry").should_not be_set
      lambda { @ie.checkbox(:id, "new_user_interests_dentistry").clear }.should raise_error(ObjectDisabledException)
      lambda { @ie.checkbox(:xpath, "//input[@id='new_user_interests_dentistry']").clear }.should raise_error(ObjectDisabledException)
    end
    it "should clear the checkbox button if it is set" do
      @ie.checkbox(:id, "new_user_interests_books").clear
      @ie.checkbox(:id, "new_user_interests_books").should_not be_set
    end
    it "should clear the checkbox button when found by :xpath" do
      @ie.checkbox(:xpath, "//input[@id='new_user_interests_books']").clear
      @ie.checkbox(:xpath, "//input[@id='new_user_interests_books']").should_not be_set
    end
    it "should raise UnknownObjectException if the checkbox button doesn't exist" do
      lambda { @ie.checkbox(:name, "no_such_id").clear }.should raise_error(UnknownObjectException)
      lambda { @ie.checkbox(:xpath, "//input[@id='no_such_id']").clear  }.should raise_error(UnknownObjectException)  
    end
  end
  
  describe "#set" do
    it "should set the checkbox button" do
      @ie.checkbox(:id, "new_user_interests_cars").set
      @ie.checkbox(:id, "new_user_interests_cars").should be_set
    end
    it "should set the checkbox button when found by :xpath" do
      @ie.checkbox(:xpath, "//input[@id='new_user_interests_cars']").set
      @ie.checkbox(:xpath, "//input[@id='new_user_interests_cars']").should be_set
    end

    it "should fire the onclick event"

    it "should raise UnknownObjectException if the checkbox button doesn't exist" do
      lambda { @ie.checkbox(:name, "no_such_name").set  }.should raise_error(UnknownObjectException)
      lambda { @ie.checkbox(:xpath, "//input[@name='no_such_name']").set  }.should raise_error(UnknownObjectException)
    end
    it "should raise ObjectDisabledException if the checkbox is disabled" do
      lambda { @ie.checkbox(:id, "new_user_interests_dentistry").set  }.should raise_error(ObjectDisabledException)
      lambda { @ie.checkbox(:xpath, "//input[@id='new_user_interests_dentistry']").set  }.should raise_error(ObjectDisabledException )
    end
  end
  
  
  # Other
  
  describe '#set?' do
    it "should return true if the checkbox button is set" do
      @ie.checkbox(:id, "new_user_interests_books").should be_set
    end
    it "should return false if the checkbox button unset" do
      @ie.checkbox(:id, "new_user_interests_cars").should_not be_set
    end
    it "should return the state for checkboxs with string values" do
      @ie.checkbox(:name, "new_user_interests", 'cars').should_not be_set
      @ie.checkbox(:name, "new_user_interests", 'cars').set
      @ie.checkbox(:name, "new_user_interests", 'cars').should be_set
      @ie.checkbox(:name, "new_user_interests", 'cars').clear
      @ie.checkbox(:name, "new_user_interests", 'cars').should_not be_set
    end
    it "should raise UnknownObjectException if the checkbox button doesn't exist" do
      lambda { @ie.checkbox(:id, "no_such_id").set?  }.should raise_error(UnknownObjectException)  
      lambda { @ie.checkbox(:xpath, "//input[@id='no_such_id']").set?  }.should raise_error(UnknownObjectException)
    end    
  end
  
  describe "#get_state" do
    it "should return true if the checkbox is set" do
      @ie.checkbox(:id, "new_user_interests_books").get_state.should be_true
    end
    it "should return false if the checkbox is unset" do
      @ie.checkbox(:id, "new_user_interests_cars").get_state.should be_false
    end
    it "should raise UnknownObjectException if the checkbox doesn't exist" do
      lambda {   @ie.checkbox(:name, "no_such_name").get_state  }.should raise_error(UnknownObjectException)
      lambda {   @ie.checkbox(:xpath, "//input[@name='no_such_name']").get_state  }.should raise_error(UnknownObjectException)
    end
  end
  
  after :all do
    @ie.close
  end
end

