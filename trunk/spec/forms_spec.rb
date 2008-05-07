require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Forms" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end

  describe "#length" do
    it "should return the number of forms in the container" do
      @ie.forms.length.should == 2
    end
  end
  
  describe "#[]n" do
    it "should provide access to the nth form" do
      @ie.forms[1].action.should == 'forms_with_input_elements.html'
      @ie.forms[1].attribute_value('method').should == 'post'     
    end
  end
  
  describe "#each" do
    it "should iterate through forms correctly" do
      @ie.forms.each_with_index do |f, index|
        f.name.should == @ie.form(:index, index+1).name
        f.id.should == @ie.form(:index, index+1).id
        f.class_name.should == @ie.form(:index, index+1).class_name
      end
    end
  end
  
  after :all do
    @ie.close
  end

end

