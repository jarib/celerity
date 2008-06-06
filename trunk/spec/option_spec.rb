require File.dirname(__FILE__) + '/spec_helper.rb'

describe Option do
  
  before :all do
    @browser = Celerity::IE.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  describe "#exists?" do
    it "should return true if the element exists (page context)" do
      @browser.option(:id, "nor").should exist
      @browser.option(:id, /nor/).should exist
      @browser.option(:value, "2").should exist
      @browser.option(:value, /2/).should exist
      @browser.option(:text, "Norway").should exist
      @browser.option(:text, /Norway/).should exist
      @browser.option(:class, "scandinavia").should exist
      @browser.option(:index, 2).should exist
      @browser.option(:xpath, "//option[@id='nor']").should exist
    end

    it "should return true if the element exists (select_list context)" do
      @browser.select_list(:name, "new_user_country").option(:id, "nor").should exist
      @browser.select_list(:name, "new_user_country").option(:id, /nor/).should exist
      @browser.select_list(:name, "new_user_country").option(:value, "2").should exist
      @browser.select_list(:name, "new_user_country").option(:value, /2/).should exist
      @browser.select_list(:name, "new_user_country").option(:text, "Norway").should exist
      @browser.select_list(:name, "new_user_country").option(:text, /Norway/).should exist
      @browser.select_list(:name, "new_user_country").option(:class, "scandinavia").should exist
      @browser.select_list(:name, "new_user_country").option(:index, 2).should exist
      @browser.select_list(:name, "new_user_country").option(:xpath, "//option[@id='nor']").should exist
    end

    it "should return true if the element exists (default how = :text)" do
      @browser.option("Swedish").should exist
      @browser.select_list(:name, "new_user_languages").option("Swedish").should exist
    end

    it "should return false if the element does not exist (page context)" do
      @browser.option(:id, "no_such_id").should_not exist
      @browser.option(:id, /no_such_id/).should_not exist
      @browser.option(:value, "no_such_value").should_not exist
      @browser.option(:value, /no_such_value/).should_not exist
      @browser.option(:text, "no_such_text").should_not exist
      @browser.option(:text, /no_such_text/).should_not exist
      @browser.option(:class, "no_such_class").should_not exist
      @browser.option(:index, 1337).should_not exist
      @browser.option(:xpath, "//option[@id='no_such_id']").should_not exist
    end

    it "should return false if the element does not exist (select_list context)" do
      @browser.select_list(:name, "new_user_country").option(:id, "no_such_id").should_not exist
      @browser.select_list(:name, "new_user_country").option(:id, /no_such_id/).should_not exist
      @browser.select_list(:name, "new_user_country").option(:value, "no_such_value").should_not exist
      @browser.select_list(:name, "new_user_country").option(:value, /no_such_value/).should_not exist
      @browser.select_list(:name, "new_user_country").option(:text, "no_such_text").should_not exist
      @browser.select_list(:name, "new_user_country").option(:text, /no_such_text/).should_not exist
      @browser.select_list(:name, "new_user_country").option(:class, "no_such_class").should_not exist
      @browser.select_list(:name, "new_user_country").option(:index, 1337).should_not exist
      @browser.select_list(:name, "new_user_country").option(:xpath, "//option[@id='no_such_id']").should_not exist
    end

    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.option(:id, 3.14).exists? }.should raise_error(ArgumentError)
      lambda { @browser.select_list(:name, "new_user_country").option(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end

    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.option(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
      lambda { @browser.select_list(:name, "new_user_country").option(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  describe "#select" do
    it "should should be able to select the chosen option (page context)" do
      @browser.select_list(:name, "new_user_country").clear_selection
      @browser.option(:text, "Denmark").select
      @browser.select_list(:name, "new_user_country").get_selected_items.should == ["Denmark"]
    end

    it "should should be able to select the chosen option (select_list context)" do
      @browser.select_list(:name, "new_user_country").clear_selection
      @browser.select_list(:name, "new_user_country").option(:text, "Denmark").select
      @browser.select_list(:name, "new_user_country").get_selected_items.should == ["Denmark"]
    end

    it "should select the option when found by text (page context)" do
      @browser.option(:text, 'Sweden').select
      @browser.option(:text, 'Sweden').should be_selected
    end

    it "should select the option when found by text (select_list context)" do
      @browser.select_list(:name, 'new_user_country').option(:text, 'Sweden').select
      @browser.select_list(:name, 'new_user_country').option(:text, 'Sweden').should be_selected
    end

    it "should fire onclick event (page context)" do
      @browser.option(:text, "Username 3").select
      @browser.text_field(:id, 'delete_user_comment').value.should == 'Don\'t do it!'
    end

    it "should fire onclick event (select_list context)" do
      @browser.select_list(:id, 'delete_user_username').option(:text, "Username 3").select
      @browser.text_field(:id, 'delete_user_comment').value.should == 'Don\'t do it!'
    end

    it "should raise UnknownObjectException if the option does not exist (page context)" do
      lambda { @browser.option(:text, "no_such_text").select }.should raise_error(UnknownObjectException)  
      lambda { @browser.option(:text, /missing/).select }.should raise_error(UnknownObjectException)  
    end

    it "should raise UnknownObjectException if the option does not exist (select_list context)" do
      lambda { @browser.select_list(:name, "new_user_country").option(:text, "no_such_text").select }.should raise_error(UnknownObjectException)  
      lambda { @browser.select_list(:name, "new_user_country").option(:text, /missing/).select }.should raise_error(UnknownObjectException)  
    end

    it "should raise MissingWayOfFindingObjectException when given a bad 'how' (page context)" do
      lambda { @browser.option(:missing, "Denmark").select }.should raise_error(MissingWayOfFindingObjectException)
    end

    it "should raise MissingWayOfFindingObjectException when given a bad 'how' (select_list context)" do
      lambda { @browser.select_list(:name, "new_user_country").option(:missing, "Denmark").select }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  describe "#class_name" do  
    it "should be able to get attributes (page context)" do
      @browser.option(:text, 'Sweden').class_name.should == "scandinavia"
    end

    it "should be able to get attributes (select_list context)" do
      @browser.select_list(:name, "new_user_country").option(:text , 'Sweden').class_name.should == "scandinavia"
    end
  end
  
  describe "#respond_to?" do
    it "should return true for all attribute methods" do
      @browser.option(:index, 1).should respond_to(:class_name)
      @browser.option(:index, 1).should respond_to(:id)
      @browser.option(:index, 1).should respond_to(:text)
      @browser.option(:index, 1).should respond_to(:name)
    end
  end
  

  after :all do
    @browser.close
  end

end