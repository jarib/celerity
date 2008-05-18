require File.dirname(__FILE__) + '/spec_helper.rb'

describe TableBodies do
  
  before :all do
    @browser = IE.new
    add_spec_checker(@browser)
  end

  before :each do
    @browser = IE.new
    @browser.goto(TEST_HOST + "/tables.html")
  end
  
  describe "#length" do
    it "should return the correct number of table bodies" do
      @browser.table(:index, 1).bodies.length.should == 2
    end
  end
  
  describe "#[]" do
    it "should return the row at the given index" do
      @browser.table(:index, 1).bodies[1].id.should == "first"
      @browser.table(:index, 1).bodies[2].name.should == "second"
    end
  end
  
  describe "#each" do
      it "should iterate through table bodies correctly" do
        table = @browser.table(:index, 1)
        table.bodies.each_with_index do |body, index|
          body.name.should == table.body(:index, index+1).name
          body.id.should == table.body(:index, index+1).id
        end
      end      
    end
  
  after :all do
    @browser.close
  end
  
end
