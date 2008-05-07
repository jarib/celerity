require File.dirname(__FILE__) + '/spec_helper.rb'

describe "FileFields" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  describe "#length" do
    it "should return the correct number of file fields" do
      @ie.file_fields.length.should == 2
    end
  end
  
  describe "#[]" do
    it "should return the file field at the given index" do
      @ie.file_fields[1].id.should == "new_user_portrait"
    end
  end
  
  describe "#each" do
    it "should iterate through file fields correctly" do
      @ie.file_fields.each_with_index do |f, index|
        f.name.should == @ie.file_field(:index, index+1).name
        f.id.should ==  @ie.file_field(:index, index+1).id
        f.value.should == @ie.file_field(:index, index+1).value
      end
    end
  end

  after :all do
    @ie.close
  end

end

