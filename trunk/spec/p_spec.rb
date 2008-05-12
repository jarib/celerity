require File.dirname(__FILE__) + '/spec_helper.rb'

describe "P" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/non_control_elements.html")
  end

  # Exists method
  describe "#exist?" do
    it "should return true if the 'p' exists" do
      @ie.p(:id, "lead").should exist
      @ie.p(:id, /lead/).should exist
      @ie.p(:text, "Dubito, ergo cogito, ergo sum.").should exist
      @ie.p(:text, /Dubito, ergo cogito, ergo sum/).should exist
      @ie.p(:class, "lead").should exist
      @ie.p(:class, /lead/).should exist
      @ie.p(:index, 1).should exist
      @ie.p(:xpath, "//p[@id='lead']").should exist
    end
    it "should return false if the 'p' doesn't exist" do
      @ie.p(:id, "no_such_id").should_not exist
      @ie.p(:id, /no_such_id/).should_not exist
      @ie.p(:text, "no_such_text").should_not exist
      @ie.p(:text, /no_such_text/).should_not exist
      @ie.p(:class, "no_such_class").should_not exist
      @ie.p(:class, /no_such_class/).should_not exist
      @ie.p(:index, 1337).should_not exist
      @ie.p(:xpath, "//p[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @ie.p(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @ie.p(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#class_name" do
    it "should return the class attribute" do
      @ie.p(:index, 1).class_name.should == 'lead'
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @ie.p(:index, 3).class_name.should == ''
    end
    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @ie.p(:id, 'no_such_id').class_name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#id" do
    it "should return the id attribute" do
      @ie.p(:index, 1).id.should == "lead"
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @ie.p(:index, 3).id.should == ''
    end
    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @ie.p(:id, "no_such_id").id }.should raise_error(UnknownObjectException)
      lambda { @ie.p(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#name" do
    it "should return the name attribute" do
      @ie.p(:index, 2).name.should == "invalid_attribute"
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @ie.p(:index, 3).name.should == ''
    end
    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @ie.p(:id, "no_such_id").name }.should raise_error(UnknownObjectException)
      lambda { @ie.p(:index, 1337).name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#title" do
    it "should return the title attribute" do
      @ie.p(:index, 1).title.should == 'Lorem ipsum'
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @ie.p(:index, 3).title.should == ''
    end
    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @ie.p(:id, 'no_such_id').title }.should raise_error( UnknownObjectException)
      lambda { @ie.p(:xpath, "//p[@id='no_such_id']").title }.should raise_error( UnknownObjectException)
    end
  end
  
  describe "#text" do
    it "should return the text of the p" do
      @ie.p(:index, 2).text.should == 'Sed pretium metus et quam. Nullam odio dolor, vestibulum non, tempor ut, vehicula sed, sapien. Vestibulum placerat ligula at quam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.'
    end
    it "should return an empty string if the element doesn't contain any text" do
      @ie.p(:index, 5).text.should == ''
    end
    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @ie.p(:id, 'no_such_id').text }.should raise_error( UnknownObjectException)
      lambda { @ie.p(:xpath , "//p[@id='no_such_id']").text }.should raise_error( UnknownObjectException)
    end
  end
  
  describe "#value" do
    it "should return the value attribute" do
      @ie.p(:index, 2).value.should == "invalid_attribute"
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @ie.p(:index, 3).value.should == ''
    end
    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @ie.p(:id , "no_such_id").value }.should raise_error(UnknownObjectException)
      lambda { @ie.p(:index , 1337).value }.should raise_error(UnknownObjectException)
    end
  end

  # Other
  describe "#to_s" do
    it "should return a human readable representation of the element" do
      @ie.p(:index, 1).to_s.should == "tag:          p\n" + 
                                      "  id:           lead\n" +
                                      "  class:        lead\n" +
                                      "  title:        Lorem ipsum\n" +
                                      "  text:         Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur eu pede. Ut justo. Praesent feugiat, elit in feugiat iaculis, sem risus rutrum justo, eget fermentum dolor arcu non nunc."
    end
    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @ie.p(:xpath, "//p[@id='no_such_id']").to_s }.should raise_error( UnknownObjectException)
    end
  end
  
  after :all do
    @ie.close
  end

end