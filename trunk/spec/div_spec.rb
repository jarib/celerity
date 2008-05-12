require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Div" do
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/non_control_elements.html")
  end
  
  
  # Exists method
  describe "#exists?" do
    it "should return true if the element exists" do
      @ie.div(:id, "header").should exist
      @ie.div(:id, /header/).should exist
      @ie.div(:title, "Header and primary navigation").should exist
      @ie.div(:title, /Header and primary navigation/).should exist
      @ie.div(:text, "This is a footer.").should exist
      @ie.div(:text, /This is a footer\./).should exist
      @ie.div(:class, "profile").should exist
      @ie.div(:class, /profile/).should exist
      @ie.div(:index, 1).should exist
      @ie.div(:xpath, "//div[@id='header']").should exist
    end
    it "should return false if the element does not exist" do
      @ie.div(:id, "no_such_id").should_not exist
      @ie.div(:id, /no_such_id/).should_not exist
      @ie.div(:title, "no_such_title").should_not exist
      @ie.div(:title, /no_such_title/).should_not exist
      @ie.div(:text, "no_such_text").should_not exist
      @ie.div(:text, /no_such_text/).should_not exist
      @ie.div(:class, "no_such_class").should_not exist
      @ie.div(:class, /no_such_class/).should_not exist
      @ie.div(:index, 1337).should_not exist
      @ie.div(:xpath, "//div[@id='no_such_id']").should_not exist
    end 
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @ie.div(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @ie.div(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#class_name" do
    it "should return the class attribute if the element exists" do
      @ie.div(:id , "footer").class_name.should == "profile"
    end
    it "should return an empty string if the element exists but the attribute doesn't" do
      @ie.div(:id , "content").class_name.should == ""
    end
    it "should raise UnknownObjectException if the element does not exist" do
      lambda { @ie.div(:id, "no_such_id").class_name }.should raise_error(UnknownObjectException)
      lambda { @ie.div(:title, "no_such_title").class_name }.should raise_error(UnknownObjectException)
      lambda { @ie.div(:index, 1337).class_name }.should raise_error(UnknownObjectException)
      lambda { @ie.div(:xpath, "//div[@id='no_such_id']").class_name }.should raise_error(UnknownObjectException)
    end
  end

  describe "#id" do
    it "should return the id attribute if the element exists" do
      @ie.div(:index, 2).id.should == "outer_container"
    end
    it "should return an empty string if the element exists, but the attribute doesn't" do
      @ie.div(:index, 1).id.should == ""
    end
    it "should raise UnknownObjectException if the element does not exist" do
      lambda {@ie.div(:id, "no_such_id").id }.should raise_error(UnknownObjectException)
      lambda {@ie.div(:title, "no_such_id").id }.should raise_error(UnknownObjectException)
      lambda {@ie.div(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#name" do
    it "should return the name attribute if the element exists" do
      @ie.div(:id, 'promo').name.should == "invalid_attribute"
    end
    it "should return an empty string if the element exists but the attribute doesn't" do
      @ie.div(:index, 1).name.should == ""
    end
    it "should raise UnknownObjectException if the element does not exist" do
      lambda {@ie.div(:id, "div77").name }.should raise_error(UnknownObjectException)
      lambda {@ie.div(:title, "div77").name }.should raise_error(UnknownObjectException)
      lambda {@ie.div(:index, 44).name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#text" do
    it "should return the text of the div" do
      @ie.div(:id, "footer").text.strip.should == "This is a footer."
      @ie.div(:title, "Closing remarks").text.strip.should == "This is a footer."
      @ie.div(:xpath, "//div[@id='footer']").text.strip.should == "This is a footer."
    end
    it "should return an empty string if the element exists but contains no text" do
      @ie.div(:index, 1).text.strip.should == ""
    end
    it "should raise UnknownObjectException if the element does not exist" do
      lambda { @ie.div(:id, "no_such_id").text }.should raise_error(UnknownObjectException)
      lambda { @ie.div(:title, "no_such_title").text }.should raise_error(UnknownObjectException)
      lambda { @ie.div(:index, 1337).text }.should raise_error(UnknownObjectException)
      lambda { @ie.div(:xpath, "//div[@id='no_such_id']").text }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#value" do
    it "should return the value attribute if the element exists" do
      @ie.div(:id, 'promo').value.should == "invalid_attribute"
    end
    it "should return an empty string if the element exists but the attribute doesn't" do
      @ie.div(:index, 1).value.should == ""
    end
    it "should raise UnknownObjectException if the element does not exist" do
      lambda {@ie.div(:id, "no_such_id").value }.should raise_error(UnknownObjectException)
      lambda {@ie.div(:title, "no_such_title").value }.should raise_error(UnknownObjectException)
      lambda {@ie.div(:index, 1337).value }.should raise_error(UnknownObjectException)
    end
  end
  
  # Manipulation methods
  describe "#click" do
    it "should fire events when clicked"
    it "should raise UnknownObjectException if the element does not exist" do
      lambda { @ie.div(:id, "no_such_id").click }.should raise_error(UnknownObjectException)
      lambda { @ie.div(:title, "no_such_title").click }.should raise_error(UnknownObjectException)
      lambda { @ie.div(:index, 1337).click }.should raise_error(UnknownObjectException)
      lambda { @ie.div(:xpath, "//div[@id='no_such_id']").click }.should raise_error(UnknownObjectException)
    end
  end

  describe "#html" do
    it "should return the HTML of the element" do
      html = @ie.div(:id, 'footer').html
      html.should include('<div id="footer" title="Closing remarks" class="profile">')
      html.should include('<span class="footer">This is a footer.</span>')
      html.should_not include('<div id="content">')
      html.should_not include('</body>')
    end
  end
  
  describe "#to_s" do
    it "should return a human readable representation of the element" do
      @ie.div(:id, 'footer').to_s.should ==  "tag:          div\n" +
                                            "  id:           footer\n" +
                                            "  title:        Closing remarks\n" +
                                            "  class:        profile\n" +
                                            "  text:         This is a footer."
    end
  end
  
  # Divs can't be disabled
  # describe "#disabled?" do
  #   it "should raise UnknownObjectException if the element does not exist" do
  #     lambda {@ie.div(:id , "div77").disabled? }.should raise_error(UnknownObjectException)
  #     lambda {@ie.div(:title , "div77").disabled? }.should raise_error(UnknownObjectException)
  #     lambda {@ie.div(:index , 44).disabled? }.should raise_error(UnknownObjectException)
  #   end
  #   
  #   it "should return false if the element is enabled" do
  #     @ie.div(:index , 2).should_not be_disabled
  #   end
  #   
  #   it "should return true if the element is disabled" 
  # end
  
  after :all do
    @ie.close
  end

end

