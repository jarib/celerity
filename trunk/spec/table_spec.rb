require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Table" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)
  end

  before :each do
    @ie = IE.new
    @ie.goto(TEST_HOST + "/tables.html")
  end
  
  # Exists
  describe "#exists?" do
    it "should return true if the table exists" do
      @ie.table(:id, 'axis_example').should exist
      @ie.table(:id, /axis_example/).should exist
      @ie.table(:index, 1).should exist
      @ie.table(:xpath, "//table[@id='axis_example']").should exist
    end
    it "should return false if the table does not exist" do
      @ie.table(:id, 'no_such_id').should_not exist
      @ie.table(:id, /no_such_id/).should_not exist
      @ie.table(:index, 1337).should_not exist
      @ie.table(:xpath, "//table[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when what argument is invalid" do
      lambda { @ie.table(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when how argument is invalid" do
      lambda { @ie.table(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Other
  describe "#to_a" do
    it "should return a two-dimensional array representation of the table" do
      @ie.table(:id, 'inner').to_a.should == [["Table 2, Row 1, Cell 1", "Table 2, Row 1, Cell 2"]]
    end
  end
  
  describe "#row_count" do
    it "should count the number of rows correctly" do
      @ie.table(:id, 'inner').row_count.should == 1
      @ie.table(:id, 'outer').row_count.should == 3
    end
    it "should raise an UnknownObjectException if the table doesn't exist" do
      lambda { @ie.table(:id, 'no_such_id').row_count }.should raise_error(UnknownObjectException)
      lambda { @ie.table(:index, 1337).row_count }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#row_values" do 
    it "should get row values" do
      @ie.table(:id, 'outer').row_values(1).should == ["Table 1, Row 1, Cell 1", "Table 1, Row 1, Cell 2"]
      @ie.table(:id, 'inner').row_values(1).should == ["Table 2, Row 1, Cell 1", "Table 2, Row 1, Cell 2"]
      @ie.table(:id, 'outer').row_values(3).should == ["Table 1, Row 3, Cell 1", "Table 1, Row 3, Cell 2"]
    end
  end
  
  describe "#column_count" do
    it "should count the number of columns correctly" do
      @ie.table(:id, 'inner').column_count.should == 2
      @ie.table(:id, 'outer').column_count.should == 2
    end
    it "should raise an UnknownObjectException if the table doesn't exist" do
      lambda { @ie.table(:id, 'no_such_id').column_count }.should raise_error(UnknownObjectException)
      lambda { @ie.table(:index, 1337).column_count }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#column_values" do
    it "should get column values" do
      @ie.table(:id, 'inner').column_values(1).should == ["Table 2, Row 1, Cell 1"]
      @ie.table(:id, 'outer').column_values(1).should == ["Table 1, Row 1, Cell 1", "Table 1, Row 2, Cell 1", "Table 1, Row 3, Cell 1"]
    end
    it "should raise UnknownCellException when trying to locate non-existing cell" do
      lambda { @ie.table(:id, 'inner').column_values(1337) }.should raise_error(UnknownCellException)
    end
  end
  
  describe "#[]" do
    it "should return the row at the given index" do
      @ie.table(:id, 'outer')[1].id.should == "outer_first"
      @ie.table(:id, 'inner')[1].id.should == "inner_first"
      @ie.table(:id, 'outer')[3].id.should == "outer_last"
    end
  end

  describe "#each" do
    it "should iterate through the table's rows" do
      index = 1
      @ie.table(:id, 'outer').each do |r|
        case index
        when 1
          r.text.should == "Table 1, Row 1, Cell 1 Table 1, Row 1, Cell 2"
        when 3
          r.text.should == "Table 1, Row 3, Cell 1 Table 1, Row 3, Cell 2"
        end
        index += 1
      end
    end
  end
  
  after :all do
    @ie.close
  end

end