require File.dirname(__FILE__) + '/spec_helper.rb'

describe Ul do
  
  before :all do
    @browser = IE.new
    add_spec_checker(@browser)    
  end

  before :each do
    @browser.goto(TEST_HOST + "/non_control_elements.html")
  end

  # Exists method
  describe "#exist?" do
    it "should return true if the 'ol' exists" do
      @browser.ol(:id, "favorite_compounds").should exist
      @browser.ol(:id, /favorite_compounds/).should exist
      @browser.ol(:index, 1).should exist
      @browser.ol(:xpath, "//ol[@id='favorite_compounds']").should exist
    end
    it "should return true if the element exists (default how = :id)" do
      @browser.ol("favorite_compounds").should exist
    end
    it "should return false if the 'ol' doesn't exist" do
      @browser.ol(:id, "no_such_id").should_not exist
      @browser.ol(:id, /no_such_id/).should_not exist
      @browser.ol(:text, "no_such_text").should_not exist
      @browser.ol(:text, /no_such_text/).should_not exist
      @browser.ol(:class, "no_such_class").should_not exist
      @browser.ol(:class, /no_such_class/).should_not exist
      @browser.ol(:index, 1337).should_not exist
      @browser.ol(:xpath, "//ol[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.ol(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.ol(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#class_name" do
    it "should return the class attribute" do
      @browser.ol(:id, 'favorite_compounds').class_name.should == 'chemistry'
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.ol(:index, 2).class_name.should == ''
    end
    it "should raise UnknownObjectException if the ol doesn't exist" do
      lambda { @browser.ol(:id, 'no_such_id').class_name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#id" do
    it "should return the id attribute" do
      @browser.ol(:class, 'chemistry').id.should == "favorite_compounds"
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.ol(:index, 2).id.should == ''
    end
    it "should raise UnknownObjectException if the ol doesn't exist" do
      lambda { @browser.ol(:id, "no_such_id").id }.should raise_error(UnknownObjectException)
      lambda { @browser.ol(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end
  
  after :all do
    @browser.close
  end

end