require File.dirname(__FILE__) + '/spec_helper.rb'

describe "TableCells" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)
  end

  before :each do
    @ie = IE.new
    @ie.goto(TEST_HOST + "/tables.html")
  end
  
#  describe "#length" do
#    it "should return the number of cells" do
#      @ie.table(:id, 'outer').cells.length.should == 6
#      @ie.table(:id, 'inner').cells.length.should == 2
#    end
#  end
#  
#  describe "#[]" do
#    it "should return the row at the given index" do
#      @ie.table(:id, 'outer').cells[1].text.should == "Table 1, Row 1, Cell 1"
#      @ie.table(:id, 'inner').cells[1].text.should == "Table 2, Row 1, Cell 1"
#      @ie.table(:id, 'outer').cells[6].text.should == "Table 1, Row 3, Cell 2"
#    end
#  end

  describe "#each" do
    it "should iterate through cells correctly" do
      # All cells on the page
      @ie.cells.each_with_index do |c, index|
        c.name.should == @ie.cell(:index, index+1).name
        c.id.should == @ie.cell(:index, index+1).id
        c.value.should == @ie.cell(:index, index+1).value
      end
      # Cells inside a table
      inner_table = @ie.table(:id, 'inner')
      inner_table.cells.each_with_index do |c, index|
        c.name.should == inner_table.cell(:index, index+1).name
        c.id.should == inner_table.cell(:index, index+1).id
        c.value.should == inner_table.cell(:index, index+1).value
      end
      # Cells inside a table (should not include cells inside a table inside a table)
      outer_table = @ie.table(:id, 'outer')
      outer_table.cells.each_with_index do |c, index|
        c.name.should == outer_table.cell(:index, index+1).name
        c.id.should == outer_table.cell(:index, index+1).id
        c.value.should == outer_table.cell(:index, index+1).value
      end      
    end
  end
  
  after :all do
    @ie.close
  end
  
end

