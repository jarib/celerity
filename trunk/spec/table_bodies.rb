require File.dirname(__FILE__) + '/spec_helper.rb'

describe "TableBody" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)
  end

  before :each do
    @ie = IE.new
    @ie.goto(TEST_HOST + "/tables.html")
  end
  
  describe "#length" do
    it "should return the number of table bodies" do
      @ie.table(:index, 1).bodies.length.should == 2
      @ie.table(:index, 2).bodies.length.should == 0
    end
  end
  
  describe "#[]n" do
    it "should return the nth table body" do
      pending
    end
  end

  describe "#each" do
    it "should iterate through table bodies correctly" do
      #@ie.table(:index, 1).bodies.each_with_index do |body, index|
      #end
      pending
    end
  end
  
  after :all do
    @ie.close
  end
  
end
