require File.dirname(__FILE__) + '/spec_helper.rb'

describe TableFooter do
  
  before :all do
    @browser = IE.new
  end

  before :each do
    @browser = IE.new
    @browser.goto(TEST_HOST + "/tables.html")
  end
  
  describe "#exists" do
    it "should return true if the table tfoot exists (page context)" do
      @browser.tfoot(:id, 'tax_totals').should exist
      @browser.tfoot(:id, /tax_totals/).should exist
      @browser.tfoot(:index, 1).should exist
      @browser.tfoot(:xpath, "//tfoot[@id='tax_totals']").should exist
    end

    it "should return true if the table tfoot exists (table context)" do
      @browser.table(:index, 1).tfoot(:id, 'tax_totals').should exist
      @browser.table(:index, 1).tfoot(:id, /tax_totals/).should exist
      @browser.table(:index, 1).tfoot(:index, 1).should exist
      @browser.table(:index, 1).tfoot(:xpath, "//tfoot[@id='tax_totals']").should exist
    end

    it "should return true if the element exists (default how = :id)" do
      @browser.tfoot("tax_totals").should exist
      @browser.table(:index, 1).tfoot("tax_totals").should exist
    end

    it "should return false if the table tfoot exists (page context)" do
      @browser.tfoot(:id, 'no_such_id').should_not exist
      @browser.tfoot(:id, /no_such_id/).should_not exist
      @browser.tfoot(:index, 1337).should_not exist
      @browser.tfoot(:xpath, "//tfoot[@id='no_such_id']").should_not exist
    end

    it "should return false if the table tfoot exists (table context)" do
      @browser.table(:index, 1).tfoot(:id, 'no_such_id').should_not exist
      @browser.table(:index, 1).tfoot(:id, /no_such_id/).should_not exist
      @browser.table(:index, 1).tfoot(:index, 1337).should_not exist
      @browser.table(:index, 1).tfoot(:xpath, "//tfoot[@id='no_such_id']").should_not exist
    end

    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.tfoot(:id, 3.14).exists? }.should raise_error(ArgumentError)
      lambda { @browser.table(:index, 1).tfoot(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end

    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.tfoot(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
      lambda { @browser.table(:index, 1).tfoot(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  describe "#length" do
    it "should return the correct number of table bodies (page context)" do
      @browser.tfoot(:id, 'tax_totals').length.should == 1
    end

    it "should return the correct number of table bodies (table context)" do
      @browser.table(:index, 1).tfoot(:id, 'tax_totals').length.should == 1
    end
  end
  
  describe "#[]" do
    it "should return the row at the given index (page context)" do
      @browser.tfoot(:id, 'tax_totals')[1].text.should == 'Sum 24 349 5 577 18 722'
      @browser.tfoot(:id, 'tax_totals')[1][2].text.should == '24 349'
      @browser.tfoot(:id, 'tax_totals')[1][3].text.should == '5 577'
    end

    it "should return the row at the given index (table context)" do
      @browser.table(:index, 1).tfoot(:id, 'tax_totals')[1].text.should == 'Sum 24 349 5 577 18 722'
      @browser.table(:index, 1).tfoot(:id, 'tax_totals')[1][2].text.should == '24 349'
      @browser.table(:index, 1).tfoot(:id, 'tax_totals')[1][3].text.should == '5 577'
    end
  end
  
  describe "#each" do
    it "should iterate through rows correctly" do
      tfoot = @browser.table(:index, 1).tfoot(:id, 'tax_totals')
      index = 1
      tfoot.each do |r|
        r.name.should == @browser.row(:index, index).name
        r.id.should == @browser.row(:index, index).id
        r.value.should == @browser.row(:index, index).value
        index += 1
      end
      index.should_not == 1
    end
  end
  
  after :all do
    @browser.close
  end
  
end