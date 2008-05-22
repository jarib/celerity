require File.dirname(__FILE__) + '/spec_helper.rb'

describe TableBody do
  
  before :all do
    @browser = IE.new
    add_spec_checker(@browser)
  end

  before :each do
    @browser = IE.new
    @browser.goto(TEST_HOST + "/tables.html")
  end
  
  describe "#exists" do
    it "should return true if the table body exists" do
      @browser.table(:index, 1).body(:id, 'first').should exist
      @browser.table(:index, 1).body(:id, /first/).should exist
      @browser.table(:index, 1).body(:name, 'second').should exist
      @browser.table(:index, 1).body(:name, /second/).should exist
      @browser.table(:index, 1).body(:index, 1).should exist
      @browser.table(:index, 1).body(:xpath, "//tbody[@id='first']").should exist
    end
    it "should return true if the element exists (default how = :id)" do
      @browser.table(:index, 1).body("first").should exist
    end
    it "should return false if the table body exists" do
      @browser.table(:index, 1).body(:id, 'no_such_id').should_not exist
      @browser.table(:index, 1).body(:id, /no_such_id/).should_not exist
      @browser.table(:index, 1).body(:name, 'no_such_name').should_not exist
      @browser.table(:index, 1).body(:name, /no_such_name/).should_not exist
      @browser.table(:index, 1).body(:index, 1337).should_not exist
      @browser.table(:index, 1).body(:xpath, "//tbody[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.table(:index, 1).body(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.table(:index, 1).body(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  describe "#length" do
    it "should return the correct number of table bodies" do
      @browser.table(:index, 1).body(:id, 'first').length.should == 3
      @browser.table(:index, 1).body(:name, 'second').length.should == 3
    end
  end
  
  describe "#[]" do
    it "should return the row at the given index" do
      @browser.table(:index, 1).body(:id, 'first')[1].text.should == 'March 2008'
      @browser.table(:index, 1).body(:id, 'first')[2][1].text.should == 'Gregory House'
      @browser.table(:index, 1).body(:id, 'first')[3][1].text.should == 'Hugh Laurie'
    end
  end
  
  describe "#each" do
      it "should iterate through rows correctly" do
        body = @browser.table(:index, 1).body(:id, 'first')
        index = 1
        body.each do |r|
          r.name.should == body.row(:index, index).name
          r.id.should == body.row(:index, index).id
          r.value.should == body.row(:index, index).value
          index += 1
        end
        index.should_not == 1
      end      
    end
  
  after :all do
    @browser.close
  end
  
end