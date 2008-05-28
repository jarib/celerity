require File.dirname(__FILE__) + '/spec_helper.rb'

describe H1, H2, H3, H4, H5, H6 do
  
  before :all do
    @browser = IE.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/non_control_elements.html")
  end

  # Exists method
  describe "#exist?" do
    it "should return true if the element exists" do
      @browser.h1(:id, "first_header").should exist
      @browser.h1(:id, /first_header/).should exist
      @browser.h1(:text, "Header 1").should exist
      @browser.h1(:text, /Header 1/).should exist
      @browser.h1(:index, 1).should exist
      @browser.h1(:xpath, "//h1[@id='first_header']").should exist
    end

    it "should return true if the element exists (default how = :id)" do
      @browser.h1("first_header").should exist
    end

    it "should return true if the element exists" do
      @browser.h1(:id, "no_such_id").should_not exist
      @browser.h1(:id, /no_such_id/).should_not exist
      @browser.h1(:text, "no_such_text").should_not exist
      @browser.h1(:text, /no_such_text 1/).should_not exist
      @browser.h1(:index, 1337).should_not exist
      @browser.h1(:xpath, "//p[@id='no_such_id']").should_not exist
    end

    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.h1(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end

    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.h1(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#class_name" do
    it "should return the class attribute" do
      @browser.h1(:index, 1).class_name.should == 'primary'
    end

    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.h2(:index, 1).class_name.should == ''
    end

    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @browser.h2(:id, 'no_such_id').class_name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#id" do
    it "should return the id attribute" do
      @browser.h1(:index, 1).id.should == "first_header"
    end

    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.h2(:index, 1).id.should == ''
    end

    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @browser.h1(:id, "no_such_id").id }.should raise_error(UnknownObjectException)
      lambda { @browser.h1(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end
 
  describe "#text" do
    it "should return the text of the element" do
      @browser.h1(:index, 1).text.should == 'Header 1'
    end

    it "should return an empty string if the element doesn't contain any text" do
      @browser.h6(:index, 1).text.should == ''
    end

    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @browser.h1(:id, 'no_such_id').text }.should raise_error( UnknownObjectException)
      lambda { @browser.h1(:xpath , "//h1[@id='no_such_id']").text }.should raise_error( UnknownObjectException)
    end
  end
  
  after :all do
    @browser.close
  end

end