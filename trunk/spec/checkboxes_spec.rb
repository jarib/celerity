require File.dirname(__FILE__) + '/spec_helper.rb'

describe "CheckBoxes" do
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end

  describe "#length" do
    it "should return the number of checkboxes" do
      @ie.checkboxes.length.should == 6
    end
  end
  
  describe "#[]" do
    it "should return the checkbox at the given index" do
      @ie.checkboxes[1].id.should == "new_user_interests_books"
    end
  end

  describe "#each" do
    it "should iterate through checkboxes correctly" do
      @ie.checkboxes.each_with_index do |c, index|
        c.name.should == @ie.checkbox(:index, index+1).name
        c.id.should == @ie.checkbox(:index, index+1).id
        c.value.should == @ie.checkbox(:index, index+1).value
      end
    end
  end
  
  after :all do
    @ie.close
  end

end