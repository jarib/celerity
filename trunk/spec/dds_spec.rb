require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Dds" do
  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/definition_lists.html")
  end

  describe "#length" do
    it "should return the number of dds" do
      @browser.dds.length.should == 11
    end
  end

  describe "#[]" do
    it "should return the dd at the given index" do
      @browser.dds[2].title.should == "education"
    end
  end

  describe "#each" do
    it "should iterate through dds correctly" do
      @browser.dds.each_with_index do |d, index|
        d.name.should == @browser.dd(:index, index+1).name
        d.id.should == @browser.dd(:index, index+1).id
        d.class_name.should == @browser.dd(:index, index+1).class_name
      end
    end
  end

  after :all do
    @browser.close
  end

end

