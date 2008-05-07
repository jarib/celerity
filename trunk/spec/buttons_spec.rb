require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Buttons" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end

  describe "#length" do
    it "should return the number of buttons" do
      @ie.buttons.length.should == 7
    end
  end
  
  describe "#[]" do
    it "should return the button at the given index" do
      @ie.buttons[1].title.should == "Submit the form"
    end
  end

  describe "#each" do
    it "should iterate through buttons correctly" do
      @ie.buttons.each_with_index do |b, index|
        b.name.should == @ie.button(:index, index+1).name
        b.id.should == @ie.button(:index, index+1).id
        b.value.should == @ie.button(:index, index+1).value
      end
    end
  end
  
  after :all do
    @ie.close
  end

end