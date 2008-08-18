require File.dirname(__FILE__) + '/spec_helper.rb'

describe "FileFields" do
  
  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  describe "#length" do
    it "should return the correct number of file fields" do
      @browser.file_fields.length.should == 2
    end
  end
  
  describe "#[]" do
    it "should return the file field at the given index" do
      @browser.file_fields[1].id.should == "new_user_portrait"
    end
  end
  
  describe "#each" do
    it "should iterate through file fields correctly" do
      @browser.file_fields.each_with_index do |f, index|
        f.name.should == @browser.file_field(:index, index+1).name
        f.id.should ==  @browser.file_field(:index, index+1).id
        f.value.should == @browser.file_field(:index, index+1).value
      end
    end
  end

  after :all do
    @browser.close
  end

end

