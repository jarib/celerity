require File.dirname(__FILE__) + '/spec_helper.rb'

describe TableCell do
  
  before :all do
    @browser = IE.new
  end

  before :each do
    @browser = IE.new
    @browser.goto(TEST_HOST + "/tables.html")
  end
  
  # Exists
  describe "#exists" do
    it "should return true when the table cell exists" do
      @browser.cell(:id, 't1_r2_c1').should exist
      @browser.cell(:id, /t1_r2_c1/).should exist
      @browser.cell(:text, 'Table 1, Row 3, Cell 1').should exist
      @browser.cell(:text, /Table 1/).should exist
      @browser.cell(:index, 1).should exist
      @browser.cell(:xpath, "//td[@id='t1_r2_c1']").should exist
    end

    it "should return true if the element exists (default how = :id)" do
      @browser.cell("t1_r2_c1").should exist
    end

    it "should return false when the table cell does not exist" do
      @browser.cell(:id, 'no_such_id').should_not exist
      @browser.cell(:id, /no_such_id/).should_not exist
      @browser.cell(:text, 'no_such_text').should_not exist
      @browser.cell(:text, /no_such_text/).should_not exist
      @browser.cell(:index, 1337).should_not exist
      @browser.cell(:xpath, "//td[@id='no_such_id']").should_not exist
    end

    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.cell(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end

    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.cell(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#text" do
    it "should return the text inside the table cell" do
      @browser.cell(:id, 't1_r2_c1').text.should == 'Table 1, Row 2, Cell 1'
      @browser.cell(:id, 't2_r1_c1').text.should == 'Table 2, Row 1, Cell 1'
    end
  end
  
  describe "#colspan" do
    it "should get the colspan attribute" do
      @browser.cell(:id, 'colspan_2').colspan.should == 2
      @browser.cell(:id, 'no_colspan').colspan.should == 1
    end
  end
  
  describe "#respond_to?" do
    it "should return true for all attribute methods" do
      @browser.cell(:index, 1).should respond_to(:text)
      @browser.cell(:index, 1).should respond_to(:colspan)
    end
  end
  
  
  after :all do
    @browser.close
  end
  
end