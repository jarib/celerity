require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Element" do

  before :all do
    @ie = IE.new
    add_spec_checker(@ie)
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end

  describe "#method_missing" do
    it "should magically return the requested attribute if the attribute is defined in the attribute list" do
      @ie.form(:index, 1).action.should == 'forms_with_input_elements.html'
    end
    it "should call the super class method if the attribute is not defined in the element's attribute list" do
      @ie.form(:index, 2).text.should == 'Username Username 1 Delete'
    end
    it "should raise NoMethodError if the requested method is not defined in the super class" do
      lambda { @ie.button(:index, 1).no_such_attribute_or_method }.should raise_error(NoMethodError)
    end
  end
  
  after :all do
    @ie.close
  end
end
