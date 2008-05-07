require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Labels" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end

  describe "#length" do
    it "should return the number of labels" do
      @ie.labels.length.should == 25
    end
  end
  
  describe "#[]" do
    it "should return the pre at the given index" do
      @ie.labels[1].id.should == "first_label"
    end
  end

  describe "#each" do
    it "should iterate through labels correctly" do
      @ie.labels.each_with_index do |l, index|
        l.name.should == @ie.label(:index, index+1).name
        l.id.should == @ie.label(:index, index+1).id
        l.value.should == @ie.label(:index, index+1).value
      end
    end
  end
  
  after :all do
    @ie.close
  end

end

