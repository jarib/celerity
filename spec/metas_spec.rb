require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Metas" do

  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
  end

  describe "#length" do
    it "should return the number of meta elements" do
      @browser.metas.length.should == 2
    end
  end

  describe "#[]" do
    it "should return the meta element at the given index" do
      @browser.metas[2].name.should == "description"
    end
  end

  describe "#each" do
    it "should iterate through meta elements correctly" do
      @browser.metas.each_with_index do |m, index|
        m.content.should == @browser.meta(:index, index+1).content
      end
    end
  end

  after :all do
    @browser.close
  end

end

