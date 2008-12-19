require File.dirname(__FILE__) + '/spec_helper.rb'

describe "SelectList" do

  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
  end

  # Exists method
  describe "#exists?" do
    it "should return true if the select list exists" do
      @browser.select_list(:id, 'new_user_country').should exist
      @browser.select_list(:id, /new_user_country/).should exist
      @browser.select_list(:name, 'new_user_country').should exist
      @browser.select_list(:name, /new_user_country/).should exist
      # TODO: check behaviour in Watir
      # @browser.select_list(:value, 'Norway').should exist
      # @browser.select_list(:value, /Norway/).should exist
      @browser.select_list(:text, 'Norway').should exist
      @browser.select_list(:text, /Norway/).should exist
      @browser.select_list(:class, 'country').should exist
      @browser.select_list(:class, /country/).should exist
      @browser.select_list(:index, 1).should exist
      @browser.select_list(:xpath, "//select[@id='new_user_country']").should exist
    end

    it "should return true if the element exists (default how = :name)" do
      @browser.select_list("new_user_country").should exist
    end

    it "should return false if the select list doesn't exist" do
      @browser.select_list(:id, 'no_such_id').should_not exist
      @browser.select_list(:id, /no_such_id/).should_not exist
      @browser.select_list(:name, 'no_such_name').should_not exist
      @browser.select_list(:name, /no_such_name/).should_not exist
      @browser.select_list(:value, 'no_such_value').should_not exist
      @browser.select_list(:value, /no_such_value/).should_not exist
      @browser.select_list(:text, 'no_such_text').should_not exist
      @browser.select_list(:text, /no_such_text/).should_not exist
      @browser.select_list(:class, 'no_such_class').should_not exist
      @browser.select_list(:class, /no_such_class/).should_not exist
      @browser.select_list(:index, 1337).should_not exist
      @browser.select_list(:xpath, "//select[@id='no_such_id']").should_not exist
    end

    it "should raise TypeError when 'what' argument is invalid" do
      lambda { @browser.select_list(:id, 3.14).exists? }.should raise_error(TypeError)
    end

    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.select_list(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end


  # Attribute methods
  describe "#class_name" do
    it "should return the class name of the select list" do
      @browser.select_list(:name, 'new_user_country').class_name.should == 'country'
    end

    it "should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @browser.select_list(:name, 'no_such_name').class_name }.should raise_error(UnknownObjectException)
    end
  end

  describe "#id" do
    it "should return the id of the element" do
      @browser.select_list(:index, 1).id.should == "new_user_country"
    end

    it "should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @browser.select_list(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end

  describe "#name" do
    it "should return the name of the element" do
      @browser.select_list(:index, 1).name.should == "new_user_country"
    end

    it "should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @browser.select_list(:index, 1337).name }.should raise_error(UnknownObjectException)
    end
  end

  describe "#type" do
    it "should return the type of the element" do
      @browser.select_list(:index, 1).type.should == "select-one"
      @browser.select_list(:index, 2).type.should == "select-multiple"
    end

    it "should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @browser.select_list(:index, 1337).type }.should raise_error(UnknownObjectException)
    end
  end

  describe "#value" do
    it "should return the value of the selected option" do
      @browser.select_list(:index, 1).value.should == "2"
      @browser.select_list(:index, 1).select(/Sweden/)
      @browser.select_list(:index, 1).value.should == "3"
    end

    it "should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @browser.select_list(:index, 1337).value }.should raise_error(UnknownObjectException)
    end
  end

  describe "#respond_to?" do
    it "should return true for all attribute methods" do
      @browser.select_list(:index, 1).should respond_to(:class_name)
      @browser.select_list(:index, 1).should respond_to(:id)
      @browser.select_list(:index, 1).should respond_to(:name)
      @browser.select_list(:index, 1).should respond_to(:type)
      @browser.select_list(:index, 1).should respond_to(:value)
    end
  end


  # Access methods
  describe "#enabled?" do
    it "should return true if the select list is enabled" do
      @browser.select_list(:name, 'new_user_country').should be_enabled
    end

    it "should return false if the select list is disabled" do
      @browser.select_list(:name, 'new_user_role').should_not be_enabled
    end

    it "should raise UnknownObjectException if the select_list doesn't exist" do
      lambda { @browser.select_list(:name, 'no_such_name').enabled? }.should raise_error(UnknownObjectException)
    end
  end

  describe "#disabled?" do
    it "should return true if the select list is disabled" do
      @browser.select_list(:index, 3).should be_disabled
    end

    it "should return false if the select list is enabled" do
      @browser.select_list(:index, 1).should_not be_disabled
    end

    it "should should raise UnknownObjectException when the select list does not exist" do
      lambda { @browser.select_list(:index, 1337).disabled? }.should raise_error(UnknownObjectException)
    end
  end

  # Other
  describe "#option" do
    it "should return an instance of Option" do
      option = @browser.select_list(:name, "new_user_country").option(:text, "Denmark")
      option.should be_instance_of(Option)
      option.value.should == "1"
    end
  end

  describe "#options" do
    it "should should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @browser.select_list(:name, 'no_such_name').options }.should raise_error(UnknownObjectException)
    end

    it "should return all the options as an Array" do
      @browser.select_list(:name, "new_user_country").options.should == ["Denmark" ,"Norway" , "Sweden" , "United Kingdom", "USA"]
    end
  end

  describe "#selected_options" do
    it "should should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @browser.select_list(:name, 'no_such_name').selected_options }.should raise_error(UnknownObjectException)
    end

    it "should get the currently selected item(s)" do
      @browser.select_list(:name, "new_user_country").selected_options.should == ["Norway"]
      @browser.select_list(:name, "new_user_languages").selected_options.should == ["English", "Norwegian"]
    end
  end

  describe "#clear_selection" do
    it "should clear the selection when possible" do
      @browser.select_list(:name, "new_user_languages").clear_selection
      @browser.select_list(:name, "new_user_languages").selected_options.should be_empty
    end

    it "should not clear selections when not possible" do
      @browser.select_list(:name , "new_user_country").clear_selection
      @browser.select_list(:name, "new_user_country").selected_options.should == ["Norway"]
    end

    it "should should raise UnknownObjectException if the select list doesn't exist" do
      lambda { @browser.select_list(:name, 'no_such_name').clear_selection }.should raise_error(UnknownObjectException)
    end
  end

  describe "#includes?" do
    it "should return true if the given option exists" do
      @browser.select_list(:name, 'new_user_country').includes?('Denmark').should be_true
    end

    it "should return false if the given option doesn't exist" do
      @browser.select_list(:name, 'new_user_country').includes?('Ireland').should be_false
    end
  end

  describe "#selected?" do
    it "should return true if the given option is selected" do
      @browser.select_list(:name, 'new_user_country').select('Denmark')
      @browser.select_list(:name, 'new_user_country').selected?('Denmark').should be_true
    end

    it "should return false if the given option is not selected" do
      @browser.select_list(:name, 'new_user_country').selected?('Sweden').should be_false
    end

    it "should raise UnknonwObjectException if the option doesn't exist" do
      lambda { @browser.select_list(:name, 'new_user_country').selected?('missing_option') }.should raise_error(UnknownObjectException)
    end
  end

  describe "#select" do
    it "should select the given item when given a String" do
      @browser.select_list(:name, "new_user_country").select("Denmark")
      @browser.select_list(:name, "new_user_country").selected_options.should == ["Denmark"]
    end

    it "should select the given item when given a Regexp" do
      @browser.select_list(:name, "new_user_country").select(/Denmark/)
      @browser.select_list(:name, "new_user_country").selected_options.should == ["Denmark"]
    end

    it "should select the given item when given an Xpath" do
      @browser.select_list(:xpath, "//select[@name='new_user_country']").select("Denmark")
      @browser.select_list(:xpath, "//select[@name='new_user_country']").selected_options.should == ["Denmark"]
    end

    it "should be able to select multiple items using :name and a String" do
      @browser.select_list(:name, "new_user_languages").clear_selection
      @browser.select_list(:name, "new_user_languages").select("Danish")
      @browser.select_list(:name, "new_user_languages").select("Swedish")
      @browser.select_list(:name, "new_user_languages").selected_options.should == ["Danish", "Swedish"]
    end

    it "should be able to select multiple items using :name and a Regexp" do
      @browser.select_list(:name, "new_user_languages").clear_selection
      @browser.select_list(:name, "new_user_languages").select(/ish/)
      @browser.select_list(:name, "new_user_languages").selected_options.should == ["Danish", "English", "Swedish"]
    end

    it "should be able to select multiple items using :xpath" do
      @browser.select_list(:xpath, "//select[@name='new_user_languages']").clear_selection
      @browser.select_list(:xpath, "//select[@name='new_user_languages']").select(/ish/)
      @browser.select_list(:xpath, "//select[@name='new_user_languages']").selected_options.should == ["Danish", "English", "Swedish"]
    end

    it "should fire onchange event when selecting an item" do
      alerts = []
      @browser.add_listener(:alert) { |_, msg| alerts << msg }
      @browser.select_list(:id, "new_user_languages").select("Danish")
      alerts.should == ['changed language']
    end

    it "should not fire onchange event when selecting an already selected item" do
      alerts = []
      @browser.add_listener(:alert) { |_, msg| alerts << msg }

      @browser.select_list(:id, "new_user_languages").clear_selection # removes the two pre-selected options
      @browser.select_list(:id, "new_user_languages").select("English")
      alerts.size.should == 3

      @browser.select_list(:id, "new_user_languages").select("English")
      alerts.size.should == 3
    end

    it "should raise NoValueFoundException if the option doesn't exist" do
      lambda { @browser.select_list(:name, "new_user_country").select("missing_option") }.should raise_error(NoValueFoundException)
      lambda { @browser.select_list(:name, "new_user_country").select(/missing_option/) }.should raise_error(NoValueFoundException)
    end
  end

  describe "#select_value" do
    it "should select the given item" do
      @browser.select_list(:name, "new_user_languages").clear_selection
      @browser.select_list(:name, "new_user_languages").select("Swedish")
      @browser.select_list(:name, "new_user_languages").selected_options.should == ["Swedish"]
    end

    it "should raise NoValueFoundException if the option doesn't exist" do
      lambda { @browser.select_list(:name, "new_user_languages").select_value("no_such_option") }.should raise_error(NoValueFoundException)
      lambda { @browser.select_list(:name, "new_user_languages").select_value(/no_such_option/) }.should raise_error(NoValueFoundException)
    end
  end

  after :all do
    @browser.close
  end

end