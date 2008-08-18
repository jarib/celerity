require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Hiddens" do
  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
  end

  describe "#length" do
    it "should return the number of hiddens" do
      @browser.hiddens.length.should == 1
    end
  end
  
  describe "#[]" do
    it "should return the Hidden at the given index" do
      @browser.hiddens[1].id.should == "new_user_interests_dolls"
    end
  end

  describe "#each" do
    it "should iterate through hiddens correctly" do
      @browser.hiddens.each_with_index do |h, index|
        h.name.should == @browser.hidden(:index, index+1).name
        h.id.should == @browser.hidden(:index, index+1).id
        h.value.should == @browser.hidden(:index, index+1).value
      end
    end
  end
  
  after :all do
    @browser.close
  end

end

