require File.dirname(__FILE__) + '/spec_helper.rb'

describe "P" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/images.html")
  end

  # Exists method
  describe "#exist?" do
    it "should return true if the 'map' exists" do
      @ie.map(:id, "triangle_map").should exist
      @ie.map(:id, /triangle_map/).should exist
      @ie.map(:name, "triangle_map").should exist
      @ie.map(:name, /triangle_map/).should exist
      @ie.map(:index, 1).should exist
      @ie.map(:xpath, "//map[@id='triangle_map']").should exist
    end
    it "should return false if the 'map' doesn't exist" do
      @ie.map(:id, "no_such_id").should_not exist
      @ie.map(:id, /no_such_id/).should_not exist
      @ie.map(:name, "no_such_id").should_not exist
      @ie.map(:name, /no_such_id/).should_not exist
      @ie.map(:index, 1337).should_not exist
      @ie.map(:xpath, "//map[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @ie.map(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @ie.map(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#id" do
    it "should return the id attribute" do
      @ie.map(:index, 1).id.should == "triangle_map"
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @ie.map(:index, 2).id.should == ''
    end
    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @ie.map(:id, "no_such_id").id }.should raise_error(UnknownObjectException)
      lambda { @ie.map(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#name" do
    it "should return the name attribute" do
      @ie.map(:index, 1).name.should == "triangle_map"
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @ie.map(:index, 2).name.should == ''
    end
    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @ie.map(:id, "no_such_id").name }.should raise_error(UnknownObjectException)
      lambda { @ie.map(:index, 1337).name }.should raise_error(UnknownObjectException)
    end
  end

  # Other
  describe "#to_s" do
    it "should return a human readable representation of the element" do
      @ie.map(:index, 1).to_s.should == "tag:          map\n" + 
                                      "  id:           triangle_map\n" +
                                      "  name:         triangle_map"
    end
    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @ie.map(:xpath, "//map[@id='no_such_id']").to_s }.should raise_error( UnknownObjectException)
    end
  end
  
  after :all do
    @ie.close
  end

end