require File.dirname(__FILE__) + '/spec_helper.rb'

describe Option do
  
  before :all do
    @browser = Celerity::IE.new
    add_spec_checker(@browser)    
  end

  before :each do
    @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  describe "#exists?" do
    it "should return true if the option exists" do
      
    end
    it "should return true if the element exists (default how = :text)" do
      #@browser.option("Swedish").should exist
    end
    it "should return false if the table row exists" do
      
    end
    it "should raise ArgumentError when 'what' argument is invalid" do
      #lambda { @browser.option(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      #lambda { @browser.option(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  describe "#select" do
    it "should should be able to select the chosen option" do
      @browser.select_list(:name, "new_user_country").clear_selection
      @browser.select_list(:name, "new_user_country").option(:text, "Denmark").select
      @browser.select_list(:name, "new_user_country").get_selected_items.should == ["Denmark"]
    end
    it "should select the option when found by text" do
      @browser.select_list(:name, 'new_user_country').option(:text, 'Sweden').select
      @browser.select_list(:name, 'new_user_country').option(:text, 'Sweden').should be_selected
    end
    it "should fire onclick event" do
      @browser.select_list(:id, 'delete_user_username').option(:text, "Username 3").select
      @browser.text_field(:id, 'delete_user_comment').value.should == 'Don\'t do it!'
    end
    it "should raise UnknownObjectException if the option does not exist" do
      lambda { @browser.select_list(:name, "new_user_country").option(:text, "no_such_text").select }.should raise_error(UnknownObjectException)  
      lambda { @browser.select_list(:name, "new_user_country").option(:text, /missing/).select }.should raise_error(UnknownObjectException)  
    end
    it "should raise MissingWayOfFindingObjectException when given a bad 'how'" do
      lambda { @browser.select_list(:name, "new_user_country").option(:missing, "Denmark").select }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  describe "#class_name" do  
    it "should be able to get attributes" do
      @browser.select_list(:name, "new_user_country").option(:text , 'Sweden').class_name.should == "scandinavia"
    end
  end

  after :all do
    @browser.close
  end

end