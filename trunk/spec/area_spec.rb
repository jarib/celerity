require File.dirname(__FILE__) + '/spec_helper.rb'

describe Area do
  
  before :all do
    @browser = IE.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/images.html")
  end

  # Exists method
  describe "#exist?" do
    it "should return true if the area exists" do
      @browser.area(:id, "NCE").should exist
      @browser.area(:id, /NCE/).should exist
      @browser.area(:name, "NCE").should exist
      @browser.area(:name, /NCE/).should exist
      @browser.area(:title, "Tables").should exist
      @browser.area(:title, /Tables/).should exist
      @browser.area(:url, "tables.html").should exist
      @browser.area(:url, /tables/).should exist
      @browser.area(:index, 1).should exist
      @browser.area(:xpath, "//area[@id='NCE']").should exist
    end

    it "should return true if the element exists (default how = :id)" do
      @browser.area("NCE").should exist
    end

    it "should return false if the area doesn't exist" do
      @browser.area(:id, "no_such_id").should_not exist
      @browser.area(:id, /no_such_id/).should_not exist
      @browser.area(:name, "no_such_id").should_not exist
      @browser.area(:name, /no_such_id/).should_not exist
      @browser.area(:title, "no_such_title").should_not exist
      @browser.area(:title, /no_such_title/).should_not exist
      @browser.area(:url, "no_such_href").should_not exist
      @browser.area(:url, /no_such_href/).should_not exist
      @browser.area(:index, 1337).should_not exist
      @browser.area(:xpath, "//area[@id='no_such_id']").should_not exist
    end

    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.area(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end

    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.area(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#id" do
    it "should return the id attribute" do
      @browser.area(:index, 1).id.should == "NCE"
    end

    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.area(:index, 3).id.should == ''
    end

    it "should raise UnknownObjectException if the area doesn't exist" do
      lambda { @browser.area(:id, "no_such_id").id }.should raise_error(UnknownObjectException)
      lambda { @browser.area(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
    
  end
  
  describe "#name" do
    it "should return the name attribute" do
      @browser.area(:index, 1).name.should == "NCE"
    end

    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.area(:index, 3).name.should == ''
    end

    it "should raise UnknownObjectException if the area doesn't exist" do
      lambda { @browser.area(:id, "no_such_id").name }.should raise_error(UnknownObjectException)
      lambda { @browser.area(:index, 1337).name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#respond_to?" do
    it "should return true for all attribute methods" do
      @browser.area(:index, 1).should respond_to(:id)
      @browser.area(:index, 1).should respond_to(:name)
    end
  end
  
  after :all do
    @browser.close
  end

end