require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Radios" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  describe "#length" do
    it "should return the number of radios" do
      @ie.radios.length.should == 5
    end
  end
  
  describe "#[]" do
    it "should return the radio button at the given index" do
      @ie.radios[1].id.should == "new_user_newsletter_yes"
    end
  end
  
  describe "#each" do
    it "should iterate through radio buttons correctly" do
      index = 1
      @ie.radios.each do |r|
        r.name.should == @ie.radio(:index, index).name
        r.id.should ==  @ie.radio(:index, index).id
        r.value.should == @ie.radio(:index, index).value
        index += 1
      end
      @ie.radios.length.should == index - 1
    end
  end

  after :all do
    @ie.close
  end
  
end
