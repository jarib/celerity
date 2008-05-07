require File.dirname(__FILE__) + '/spec_helper.rb'

describe "SelectLists" do
  before :all do
    @ie = Celerity::IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  describe "#length" do
    it "should return the correct number of select lists on the page" do
      @ie.select_lists.length.should == 4
    end
  end
  
  describe "#[]" do
    it "should return the correct item" do
      @ie.select_lists[1].value.should == "Norway"
      @ie.select_lists[1].name.should == "new_user_country"
      @ie.select_lists[1].type.should == "select-one"
      @ie.select_lists[2].type.should == "select-multiple"
    end
  end
  
  describe "#each" do
    it "should iterate through the select lists correctly" do
      index=1
      @ie.select_lists.each do |l|
        @ie.select_list(:index, index).name.should == l.name 
        @ie.select_list(:index, index).id.should ==  l.id 
        @ie.select_list(:index, index).type.should == l.type 
        @ie.select_list(:index, index).value.should == l.value 
        index += 1
      end
      (index - 1).should == @ie.select_lists.length
    end
  end
  
  after :all do
    @ie.close
  end

end

