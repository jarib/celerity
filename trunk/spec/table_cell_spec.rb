require File.dirname(__FILE__) + '/spec_helper.rb'

describe "TableCell" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)
  end

  before :each do
    @ie = IE.new
    @ie.goto(TEST_HOST + "/tables.html")
  end
  
  # Exists
  describe "#exists" do
    it "should return true when the table cell exists" do
      @ie.cell(:id, 't1_r2_c1').should exist
      @ie.cell(:id, /t1_r2_c1/).should exist
      @ie.cell(:text, 'Table 1, Row 3, Cell 1').should exist
      @ie.cell(:text, /Table 1/).should exist
      @ie.cell(:index, 1).should exist
      @ie.cell(:xpath, "//td[@id='t1_r2_c1']").should exist
    end
    it "should return false when the table cell does not exist" do
      @ie.cell(:id, 'no_such_id').should_not exist
      @ie.cell(:id, /no_such_id/).should_not exist
      @ie.cell(:text, 'no_such_text').should_not exist
      @ie.cell(:text, /no_such_text/).should_not exist
      @ie.cell(:index, 1337).should_not exist
      @ie.cell(:xpath, "//td[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when what argument is invalid" do
      lambda { @ie.cell(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when how argument is invalid" do
      lambda { @ie.cell(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#text" do
    it "should return the text inside the table cell" do
      @ie.cell(:id, 't1_r2_c1').text.should == 'Table 1, Row 2, Cell 1'
      @ie.cell(:id, 't2_r1_c1').text.should == 'Table 2, Row 1, Cell 1'
    end
  end
  
  describe "#colspan" do
    it "should get the colspan attribute" do
      @ie.cell(:id, 'colspan_2').colspan.should == 2
      @ie.cell(:id, 'no_colspan').colspan.should == 1
    end
  end
  
  after :all do
    @ie.close
  end
  
  
end
