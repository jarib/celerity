require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Span" do
  
  before :all do
    @browser = Browser.new
  end
  
  before :each do
    @browser.goto(TEST_HOST + "/non_control_elements.html")
  end

  # Exists method
  describe "#exist?" do
    it "should return true if the 'span' exists" do
      @browser.span(:id, "lead").should exist
      @browser.span(:id, /lead/).should exist
      @browser.span(:text, "Dubito, ergo cogito, ergo sum.").should exist
      @browser.span(:text, /Dubito, ergo cogito, ergo sum/).should exist
      @browser.span(:class, "lead").should exist
      @browser.span(:class, /lead/).should exist
      @browser.span(:index, 1).should exist
      @browser.span(:xpath, "//span[@id='lead']").should exist
    end

    it "should return true if the element exists (default how = :id)" do
      @browser.span("lead").should exist
    end

    it "should return false if the 'p' doesn't exist" do
      @browser.span(:id, "no_such_id").should_not exist
      @browser.span(:id, /no_such_id/).should_not exist
      @browser.span(:text, "no_such_text").should_not exist
      @browser.span(:text, /no_such_text/).should_not exist
      @browser.span(:class, "no_such_class").should_not exist
      @browser.span(:class, /no_such_class/).should_not exist
      @browser.span(:index, 1337).should_not exist
      @browser.span(:xpath, "//span[@id='no_such_id']").should_not exist
    end

    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.span(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end

    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.span(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#class_name" do
    it "should return the class attribute" do
      @browser.span(:index, 1).class_name.should == 'lead'
    end

    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.span(:index, 3).class_name.should == ''
    end

    it "should raise UnknownObjectException if the span doesn't exist" do
      lambda { @browser.span(:id, 'no_such_id').class_name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#id" do
    it "should return the id attribute" do
      @browser.span(:index, 1).id.should == "lead"
    end

    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.span(:index, 3).id.should == ''
    end

    it "should raise UnknownObjectException if the span doesn't exist" do
      lambda { @browser.span(:id, "no_such_id").id }.should raise_error(UnknownObjectException)
      lambda { @browser.span(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#name" do
    it "should return the name attribute" do
      @browser.span(:index, 2).name.should == "invalid_attribute"
    end

    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.span(:index, 3).name.should == ''
    end

    it "should raise UnknownObjectException if the span doesn't exist" do
      lambda { @browser.span(:id, "no_such_id").name }.should raise_error(UnknownObjectException)
      lambda { @browser.span(:index, 1337).name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#title" do
    it "should return the title attribute" do
      @browser.span(:index, 1).title.should == 'Lorem ipsum'
    end

    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.span(:index, 3).title.should == ''
    end

    it "should raise UnknownObjectException if the span doesn't exist" do
      lambda { @browser.span(:id, 'no_such_id').title }.should raise_error( UnknownObjectException)
      lambda { @browser.span(:xpath, "//span[@id='no_such_id']").title }.should raise_error( UnknownObjectException)
    end
  end
  
  describe "#text" do
    it "should return the text of the span" do
      @browser.span(:index, 2).text.should == 'Sed pretium metus et quam. Nullam odio dolor, vestibulum non, tempor ut, vehicula sed, sapien. Vestibulum placerat ligula at quam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.'
    end

    it "should return an empty string if the element doesn't contain any text" do
      @browser.span(:index, 5).text.should == ''
    end

    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @browser.span(:id, 'no_such_id').text }.should raise_error( UnknownObjectException)
      lambda { @browser.span(:xpath , "//span[@id='no_such_id']").text }.should raise_error( UnknownObjectException)
    end
  end
  
  describe "#value" do
    it "should return the value attribute" do
      @browser.span(:index, 2).value.should == "invalid_attribute"
    end

    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.span(:index, 3).value.should == ''
    end

    it "should raise UnknownObjectException if the span doesn't exist" do
      lambda { @browser.span(:id , "no_such_id").value }.should raise_error(UnknownObjectException)
      lambda { @browser.span(:index , 1337).value }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#respond_to?" do
    it "should return true for all attribute methods" do
      @browser.image(:index, 1).should respond_to(:class_name)
      @browser.image(:index, 1).should respond_to(:id)
      @browser.image(:index, 1).should respond_to(:name)
      @browser.image(:index, 1).should respond_to(:title)
      @browser.image(:index, 1).should respond_to(:text)
      @browser.image(:index, 1).should respond_to(:value)
    end
  end
  

  # Other
  describe "#click" do
    it "should fire events" do
      @browser.span(:name, 'footer').text.should_not include('Javascript')
      @browser.span(:name, 'footer').click
      @browser.span(:name, 'footer').text.should include('Javascript')
    end

    it "should raise UnknownObjectException if the span doesn't exist" do
      lambda { @browser.span(:id, "no_such_id").click }.should raise_error(UnknownObjectException)
      lambda { @browser.span(:title, "no_such_title").click }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#to_s" do
    it "should return a human readable representation of the element" do
      @browser.span(:index, 2).to_s.should == "tag:          span\n" + 
                                      "  name:         invalid_attribute\n" +
                                      "  value:        invalid_attribute\n" +
                                      "  text:         Sed pretium metus et quam. Nullam odio dolor, vestibulum non, tempor ut, vehicula sed, sapien. Vestibulum placerat ligula at quam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas."
    end

    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @browser.span(:xpath, "//span[@id='no_such_id']").to_s }.should raise_error( UnknownObjectException)
    end
  end

  after :all do
    @browser.close
  end

end

