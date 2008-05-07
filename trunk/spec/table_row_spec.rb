require File.dirname(__FILE__) + '/spec_helper.rb'

describe "TableRow" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)
  end

  before :each do
    @ie = IE.new
    @ie.goto(TEST_HOST + "/tables.html")
  end
  
  describe "#column_count" do
    it "should return the number of columns (cells) in the row" do
      @ie.table(:id, 'outer').rows[1].column_count.should == 2
      @ie.table(:id, 'outer')[2].column_count.should == 2
      @ie.table(:id, 'colspan')[1].column_count.should == 1
      @ie.table(:id, 'colspan').rows[2].column_count.should == 2
      @ie.rows[1].column_count.should == 4
    end
  end
  
  describe "#length" do
    it "should return the number of rows" do
      @ie.table(:id, 'outer').rows.length.should == 3
      @ie.table(:id, 'inner').rows.length.should == 1
    end
  end
  
  describe "#[]n" do
    it "should " do
      @ie.table(:id, 'outer').row(:index, 1)[1].text.should == "Table 1, Row 1, Cell 1"
      @ie.table(:id, 'outer')[1][1].text.should == "Table 1, Row 1, Cell 1"
      @ie.table(:id, 'outer')[3][1].text.should == "Table 1, Row 3, Cell 1"
    end
  end
  
  describe "#each" do
    it "should " do
      index = 1
      @ie.table(:id, 'outer')[2].each do |c|
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
    @ie.close
  end
  
end
