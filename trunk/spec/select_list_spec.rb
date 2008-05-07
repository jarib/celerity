require File.dirname(__FILE__) + '/spec_helper.rb'

describe "SelectList" do
  before :all do
    @ie = Celerity::IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  
  # Exists method

  describe "#exists?" do
    it "should return true if the select list exists" do
      @ie.select_list(:id, 'new_user_country').should exist
      @ie.select_list(:id, /new_user_country/).should exist
      @ie.select_list(:name, 'new_user_country').should exist
      @ie.select_list(:name, /new_user_country/).should exist
      
      # check behaviour in Watir
      # @ie.select_list(:value, 'Norway').should exist
      # @ie.select_list(:value, /Norway/).should exist

      # not sure what :text is for input elements
      # @ie.select_list(:text, 'Norway').should exist
      # @ie.select_list(:text, /Norway/).should exist
      @ie.select_list(:class, 'country').should exist
      @ie.select_list(:class, /country/).should exist
      @ie.select_list(:index, 1).should exist
      @ie.select_list(:xpath, "//select[@id='new_user_country']").should exist
    end
    it "should return false if the select list doesn't exist" do
      @ie.select_list(:id, 'no_such_id').should_not exist
      @ie.select_list(:id, /no_such_id/).should_not exist
      @ie.select_list(:name, 'no_such_name').should_not exist
      @ie.select_list(:name, /no_such_name/).should_not exist
      @ie.select_list(:value, 'no_such_value').should_not exist
      @ie.select_list(:value, /no_such_value/).should_not exist
      @ie.select_list(:text, 'no_such_text').should_not exist
      @ie.select_list(:text, /no_such_text/).should_not exist
      @ie.select_list(:class, 'no_such_class').should_not exist
      @ie.select_list(:class, /no_such_class/).should_not exist
      @ie.select_list(:index, 1337).should_not exist
      @ie.select_list(:xpath, "//select[@id='no_such_id']").should_not exist
    end
    
    it "should raise ArgumentError when what argument is invalid" do
      lambda { @ie.select_list(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    
    it "should raise MissingWayOfFindingObjectException when how argument is invalid" do
      lambda { @ie.select_list(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  
  # Attribute methods
  
  describe "#class_name" do
    it "should return the class name of the select list" do
      @ie.select_list(:name, 'new_user_country').class_name.should == 'country'
    end
    it "should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @ie.select_list(:name, 'no_such_name').class_name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#id" do
    it "should return the id of the element" do
      @ie.select_list(:index, 1).id.should == "new_user_country"
    end
    it "should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @ie.select_list(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#name" do
    it "should return the name of the element" do
      @ie.select_list(:index, 1).name.should == "new_user_country"
    end
    it "should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @ie.select_list(:index, 1337).name }.should raise_error(UnknownObjectException)
    end
  end
  
  it "should should raise UnknownObjectException when the select list does not exist" do
    lambda { @ie.select_list(:index, 1337).disabled? }.should raise_error(UnknownObjectException)
  end
  
  describe "#type" do
    it "should return the type of the element" do
      @ie.select_list(:index, 1).type.should == "select-one"
      @ie.select_list(:index, 2).type.should == "select-multiple"
    end
    it "should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @ie.select_list(:index, 1337).type }.should raise_error(UnknownObjectException)
    end
  end

  describe "#value" do      
    it "should return the value of the selected option" do
      @ie.select_list(:index, 1).value.should == "Norway"
      @ie.select_list(:index, 1).select(/Sweden/)
      @ie.select_list(:index, 1).value.should == "Sweden"
    end
    it "should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @ie.select_list(:index, 1337).value  }.should raise_error(UnknownObjectException)
    end
  end

  
  # Access methods
  
  describe "#enabled?" do
    it "should return true if the select list is enabled" do
      @ie.select_list(:name, 'new_user_country').should be_enabled
    end
    it "should return false if the select list is disabled" do
      @ie.select_list(:name, 'new_user_role').should_not be_enabled
    end
    it "should raise UnknownObjectException if the select_list doesn't exist" do
      lambda { @ie.select_list(:name, 'no_such_name').enabled? }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#disabled?" do
    it "should return true if the select list is disabled" do
      @ie.select_list(:index, 3).should be_disabled
    end
    it "should return false if the select list is enabled" do
      @ie.select_list(:index, 1).should_not be_disabled
    end
  end
  
  
  # Other
  
  describe "#option" do
    it "should return an instance of Option" do
      @ie.select_list(:name, "new_user_country").option(:text, "Denmark").should be_instance_of(Celerity::Option)
    end     
    
    # do we need a seperate spec for this object?
    it "should should be able to select the chosen option" do
      @ie.select_list(:name , "new_user_country").clear_selection
      @ie.select_list(:name , "new_user_country").option(:text, "Denmark").select
      @ie.select_list(:name, "new_user_country").get_selected_items.should == ["Denmark"]
    end
    
    it "should select the option when found by text" do
      @ie.select_list(:name, 'new_user_country').option(:text, 'Sweden').select
      @ie.select_list(:name, 'new_user_country').option(:text, 'Sweden').should be_selected
    end
    
    it "should raise UnknownObjectException if the option does not exist" do
      lambda { @ie.select_list(:name, "new_user_country").option(:text, "no_such_text").select }.should raise_error(UnknownObjectException)  
      lambda { @ie.select_list(:name, "new_user_country").option(:text, /missing/).select }.should raise_error(UnknownObjectException)  
    end

    it "should raise MissingWayOfFindingObjectException when given a bad 'how'" do
      lambda { @ie.select_list(:name, "new_user_country").option(:missing, "Denmark").select }.should raise_error(MissingWayOfFindingObjectException)
    end
    
    it "should be able to get attributes" do
      @ie.select_list(:name, "new_user_country").option(:text , 'Sweden').class_name.should == "scandinavia"
      lambda { @ie.select_list(:name, "new_user_country").option(:text, "no_such_text").class_name }.should raise_error(UnknownObjectException)
    end
  end
    
  describe "#get_all_contents" do
    it "should should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @ie.select_list(:name, 'no_such_name').get_all_contents }.should raise_error(UnknownObjectException)
    end
    it "should return all the options as an Array" do
      @ie.select_list(:name, "new_user_country").get_all_contents.should == ["Denmark" ,"Norway" , "Sweden" , "United Kingdom", "USA"]
    end
  end
  
  describe "#get_selected_items" do
    it "should should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @ie.select_list(:name, 'no_such_name').get_selected_items }.should raise_error(UnknownObjectException)
    end
    
    it "should get the currently selected item(s)" do
      @ie.select_list(:name, "new_user_country").get_selected_items.should == ["Norway"]
      @ie.select_list(:name, "new_user_languages").get_selected_items.should == ["English", "Norwegian"]
    end
  end
  
  describe "#clear_selection" do
    it "should clear the selection when possible" do
      @ie.select_list(:name, "new_user_languages").clear_selection
      @ie.select_list(:name, "new_user_languages").get_selected_items.should be_empty
    end
    it "should not clear selections when not possible" do
      @ie.select_list(:name , "new_user_country").clear_selection
      @ie.select_list(:name, "new_user_country").get_selected_items.should == ["Norway"]
    end
    it "should should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @ie.select_list(:name, 'no_such_name').clear_selection }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#includes?" do
    it "should return true if the given option exists" do
      @ie.select_list(:name, 'new_user_country').includes?('Denmark').should be_true
    end
    it "should return false if the given option doesn't exist" do
      @ie.select_list(:name, 'new_user_country').includes?('Ireland').should be_false
    end
  end
  
  describe "#selected?" do
    it "should return true if the given option is selected" do
      @ie.select_list(:name, 'new_user_country').select('Denmark')
      @ie.select_list(:name, 'new_user_country').selected?('Denmark').should be_true
    end
    it "should return false if the given option is not selected" do
      @ie.select_list(:name, 'new_user_country').selected?('Sweden').should be_false
    end
    it "should raise UnknonwObjectException if the option doesn't exist" do
      lambda { @ie.select_list(:name, 'new_user_country').selected?('missing_option') }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#select" do
    it "should select the given item when given a String" do
      @ie.select_list(:name, "new_user_country").select("Denmark")
      @ie.select_list(:name, "new_user_country").get_selected_items.should == ["Denmark"]
    end
    it "should select the given item when given a Regexp" do
      @ie.select_list(:name, "new_user_country").select(/Denmark/)
      @ie.select_list(:name, "new_user_country").get_selected_items.should == ["Denmark"]
    end
    it "should select the given item when given an Xpath" do
      @ie.select_list(:xpath, "//select[@name='new_user_country']").select("Denmark")
      @ie.select_list(:xpath, "//select[@name='new_user_country']").get_selected_items.should == ["Denmark"]
    end
    it "should be able to select multiple items using :name and a String" do
      @ie.select_list(:name, "new_user_languages").clear_selection
      @ie.select_list(:name, "new_user_languages").select("Danish")
      @ie.select_list(:name, "new_user_languages").select("Swedish")
      @ie.select_list(:name, "new_user_languages").get_selected_items.should == ["Danish", "Swedish"] 
    end
    it "should be able to select multiple items using :name and a Regexp" do
      @ie.select_list(:name, "new_user_languages").clear_selection
      @ie.select_list(:name, "new_user_languages").select(/ish/)
      @ie.select_list(:name, "new_user_languages").get_selected_items.should == ["Danish", "English", "Swedish"]
    end
    it "should be able to select multiple items using :xpath" do
      @ie.select_list(:xpath, "//select[@name='new_user_languages']").clear_selection
      @ie.select_list(:xpath, "//select[@name='new_user_languages']").select( /ish/ )
      @ie.select_list(:xpath, "//select[@name='new_user_languages']").get_selected_items.should == ["Danish", "English", "Swedish"]
    end
    
    it "should fire onchange event when selecting an item"

    it "should not fire onchange event when selecting an already selected item"

    it "should raise NoValueFoundException if the option doesn't exist" do
      lambda { @ie.select_list(:name, "new_user_country").select("missing_option") }.should raise_error(NoValueFoundException)
      lambda { @ie.select_list(:name, "new_user_country").select(/missing_option/) }.should raise_error(NoValueFoundException)
    end
  end
  
  describe "#select_value" do
    it "should select the given item" do
      @ie.select_list(:name, "new_user_languages").clear_selection
      @ie.select_list(:name, "new_user_languages").select("Swedish")
      @ie.select_list(:name, "new_user_languages").get_selected_items.should == ["Swedish"]
    end
    it "should raise NoValueFoundException if the option doesn't exist" do
      lambda { @ie.select_list(:name, "new_user_languages").select_value("no_such_option") }.should raise_error(NoValueFoundException)
      lambda { @ie.select_list(:name, "new_user_languages").select_value(/no_such_option/) }.should raise_error(NoValueFoundException)
    end
  end

  after :all do
    @ie.close
  end

end

