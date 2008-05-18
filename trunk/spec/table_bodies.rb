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
  
  describe "#length" do
    it "should return the number of table bodies" do
      @browser.table(:index, 1).bodies.length.should == 2
      @browser.table(:index, 2).bodies.length.should == 0
    end
  end
  
  describe "#[]n" do
    it "should return the nth table body" do
      pending
    end
  end

  describe "#each" do
    it "should iterate through table bodies correctly" do
      #@browser.table(:index, 1).bodies.each_with_index do |body, index|
      #end
      pending
    end
  end
  
  after :all do
    @browser.close
  end
  
end
