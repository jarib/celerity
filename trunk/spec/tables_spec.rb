require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Tables" do
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/tables.html")
  end

  describe "#length" do
    it "should return the number of tables" do
      @ie.tables.length.should == 4
    end
  end
  
  describe "#[]" do
    it "should return the p at the given index" do
      @ie.tables[1].id.should == "axis_example"
      @ie.tables[2].id.should == "outer"
      @ie.tables[3].id.should == "inner"
    end
  end

  describe "#each" do
    it "should iterate through tables correctly" do
      @ie.tables.each_with_index do |t, index|
        t.name.should == @ie.table(:index, index+1).name
        t.id.should == @ie.table(:index, index+1).id
        t.value.should == @ie.table(:index, index+1).value
      end
    end
  end
  
  after :all do
    @ie.close
  end

end

