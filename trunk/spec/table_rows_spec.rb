require File.dirname(__FILE__) + '/spec_helper.rb'

describe "TableRows" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)
  end

  before :each do
    @ie = IE.new
    @ie.goto(TEST_HOST + "/tables.html")
  end
  
  describe "#length" do
    it "should return the correct number of cells (table context)" do
      @ie.table(:id, 'inner').rows.length.should == 1
      @ie.table(:id, 'outer').rows.length.should == 3
    end
    it "should return the correct number of cells (page context)" do
      @ie.rows.length.should == 14
    end
  end
  
  describe "#[]" do
    it "should return the row at the given index (table context)" do
      @ie.table(:id, 'outer').rows[1].text.should == "Table 1, Row 1, Cell 1 Table 1, Row 1, Cell 2"
    end
    it "should return the row at the given index (page context)" do
      @ie.rows[1].text.should == "Before income tax Income tax After income tax"
    end
  end
  
  describe "#each" do
      it "should iterate through rows correctly" do
      # rows inside a table
      inner_table = @ie.table(:id, 'inner')
      inner_table.rows.each_with_index do |r, index|
        r.name.should == inner_table.row(:index, index+1).name
        r.id.should == inner_table.row(:index, index+1).id
        r.value.should == inner_table.row(:index, index+1).value
      end
      # rows inside a table (should not include rows inside a table inside a table)
      outer_table = @ie.table(:id, 'outer')
      outer_table.rows.each_with_index do |r, index|
        r.name.should == outer_table.row(:index, index+1).name
        r.id.should == outer_table.row(:index, index+1).id
        r.value.should == outer_table.row(:index, index+1).value
      end
    end
  end
  
  after :all do
    @ie.close
  end
  
end
