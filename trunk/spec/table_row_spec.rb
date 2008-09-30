require File.dirname(__FILE__) + '/spec_helper.rb'

describe "TableRow" do

  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser = Browser.new
    @browser.goto(TEST_HOST + "/tables.html")
  end

  describe "#exists?" do
    it "should return true if the table row exists" do
      @browser.row(:id, "outer_first").should exist
      @browser.row(:id, /outer_first/).should exist
      @browser.row(:index, 1).should exist
      @browser.row(:xpath, "//tr[@id='outer_first']")
    end

    it "should return true if the element exists (default how = :id)" do
      @browser.row("outer_last").should exist
    end

    it "should return false if the table row exists" do
      @browser.row(:id, "no_such_id").should_not exist
      @browser.row(:id, /no_such_id/).should_not exist
      @browser.row(:index, 1337).should_not exist
      @browser.row(:xpath, "//tr[@id='no_such_id']")
    end

    it "should raise TypeError when 'what' argument is invalid" do
      lambda { @browser.row(:id, 3.14).exists? }.should raise_error(TypeError)
    end

    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.row(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end

  describe "#column_count" do
    it "should return the number of columns (cells) in the row" do
      @browser.table(:id, 'outer').rows[1].column_count.should == 2
      @browser.table(:id, 'outer')[2].column_count.should == 2
      @browser.table(:id, 'colspan')[1].column_count.should == 1
      @browser.table(:id, 'colspan').rows[2].column_count.should == 2
      @browser.rows[1].column_count.should == 4
    end
  end

  describe "#length" do
    it "should return the number of rows" do
      @browser.table(:id, 'outer').rows.length.should == 3
      @browser.table(:id, 'inner').rows.length.should == 1
    end
  end

  describe "#[]" do
    it "should return the nth cell of the parent row" do
      @browser.table(:id, 'outer').row(:index, 1)[1].text.should == "Table 1, Row 1, Cell 1"
      @browser.table(:id, 'outer')[1][1].text.should == "Table 1, Row 1, Cell 1"
      @browser.table(:id, 'outer')[3][1].text.should == "Table 1, Row 3, Cell 1"
    end

    it "should raise UnknownCellException if the index is out of bounds" do
      lambda { @browser.table(:id, 'outer').row(:index, 1)[1337] }.should raise_error(UnknownCellException)
      lambda { @browser.table(:id, 'outer')[1][1337] }.should raise_error(UnknownCellException)
    end
  end

  describe "#child_cell" do
    it "should return the nth cell of the parent row" do
      @browser.table(:id, 'outer').row(:index, 1).child_cell(1).text.should == "Table 1, Row 1, Cell 1"
      @browser.table(:id, 'outer')[1].child_cell(1).text.should == "Table 1, Row 1, Cell 1"
      @browser.table(:id, 'outer')[3].child_cell(1).text.should == "Table 1, Row 3, Cell 1"
    end

    it "should raise UnknownCellException if the index is out of bounds" do
      lambda { @browser.table(:id, 'outer').row(:index, 1).child_cell(1337) }.should raise_error(UnknownCellException)
      lambda { @browser.table(:id, 'outer')[1].child_cell(1337) }.should raise_error(UnknownCellException)
    end
  end

  describe "#each" do
    it "should iterate correctly through the cells of the row" do
      index = 1
      @browser.table(:id, 'outer')[2].each do |c|
        case index
        when 1
          c.text.should == "Table 1, Row 2, Cell 1"
        when 2
          c.text.should == "Table 1, Row 2, Cell 2 Table 2, Row 1, Cell 1 Table 2, Row 1, Cell 2"
        end
        index += 1
      end
    end
  end

  after :all do
    @browser.close
  end

end
