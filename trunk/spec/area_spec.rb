require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Area" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/images.html")
  end

  # Exists method
  describe "#exist?" do
    it "should return true if the area exists" do
      @ie.area(:id, "NCE").should exist
      @ie.area(:id, /NCE/).should exist
      @ie.area(:name, "NCE").should exist
      @ie.area(:name, /NCE/).should exist
      @ie.area(:title, "Tables").should exist
      @ie.area(:title, /Tables/).should exist
      @ie.area(:url, "tables.html").should exist
      @ie.area(:url, /tables/).should exist
      @ie.area(:index, 1).should exist
      @ie.area(:xpath, "//area[@id='NCE']").should exist
    end
    it "should return false if the area doesn't exist" do
      @ie.area(:id, "no_such_id").should_not exist
      @ie.area(:id, /no_such_id/).should_not exist
      @ie.area(:name, "no_such_id").should_not exist
      @ie.area(:name, /no_such_id/).should_not exist
      @ie.area(:title, "no_such_title").should_not exist
      @ie.area(:title, /no_such_title/).should_not exist
      @ie.area(:url, "no_such_href").should_not exist
      @ie.area(:url, /no_such_href/).should_not exist
      @ie.area(:index, 1337).should_not exist
      @ie.area(:xpath, "//area[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @ie.area(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @ie.area(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#id" do
    it "should return the id attribute" do
      @ie.area(:index, 1).id.should == "NCE"
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @ie.area(:index, 3).id.should == ''
    end
    it "should raise UnknownObjectException if the area doesn't exist" do
      lambda { @ie.area(:id, "no_such_id").id }.should raise_error(UnknownObjectException)
      lambda { @ie.area(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#name" do
    it "should return the name attribute" do
      @ie.area(:index, 1).name.should == "NCE"
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @ie.area(:index, 3).name.should == ''
    end
    it "should raise UnknownObjectException if the area doesn't exist" do
      lambda { @ie.area(:id, "no_such_id").name }.should raise_error(UnknownObjectException)
      lambda { @ie.area(:index, 1337).name }.should raise_error(UnknownObjectException)
    end
  end

  after :all do
    @ie.close
  end

end