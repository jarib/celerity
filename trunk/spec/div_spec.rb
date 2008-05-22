require File.dirname(__FILE__) + '/spec_helper.rb'

describe Div do
  
  before :all do
    @browser = IE.new
    add_spec_checker(@browser)    
  end

  before :each do
    @browser.goto(TEST_HOST + "/non_control_elements.html")
  end
  
  
  # Exists method
  describe "#exists?" do
    it "should return true if the element exists" do
      @browser.div(:id, "header").should exist
      @browser.div(:id, /header/).should exist
      @browser.div(:title, "Header and primary navigation").should exist
      @browser.div(:title, /Header and primary navigation/).should exist
      @browser.div(:text, "This is a footer.").should exist
      @browser.div(:text, /This is a footer\./).should exist
      @browser.div(:class, "profile").should exist
      @browser.div(:class, /profile/).should exist
      @browser.div(:index, 1).should exist
      @browser.div(:xpath, "//div[@id='header']").should exist
    end
    it "should return true if the element exists (default how = :id)" do
      @browser.div("header").should exist
    end
    it "should return false if the element does not exist" do
      @browser.div(:id, "no_such_id").should_not exist
      @browser.div(:id, /no_such_id/).should_not exist
      @browser.div(:title, "no_such_title").should_not exist
      @browser.div(:title, /no_such_title/).should_not exist
      @browser.div(:text, "no_such_text").should_not exist
      @browser.div(:text, /no_such_text/).should_not exist
      @browser.div(:class, "no_such_class").should_not exist
      @browser.div(:class, /no_such_class/).should_not exist
      @browser.div(:index, 1337).should_not exist
      @browser.div(:xpath, "//div[@id='no_such_id']").should_not exist
    end 
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.div(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.div(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#class_name" do
    it "should return the class attribute if the element exists" do
      @browser.div(:id , "footer").class_name.should == "profile"
    end
    it "should return an empty string if the element exists but the attribute doesn't" do
      @browser.div(:id , "content").class_name.should == ""
    end
    it "should raise UnknownObjectException if the element does not exist" do
      lambda { @browser.div(:id, "no_such_id").class_name }.should raise_error(UnknownObjectException)
      lambda { @browser.div(:title, "no_such_title").class_name }.should raise_error(UnknownObjectException)
      lambda { @browser.div(:index, 1337).class_name }.should raise_error(UnknownObjectException)
      lambda { @browser.div(:xpath, "//div[@id='no_such_id']").class_name }.should raise_error(UnknownObjectException)
    end
  end

  describe "#id" do
    it "should return the id attribute if the element exists" do
      @browser.div(:index, 2).id.should == "outer_container"
    end
    it "should return an empty string if the element exists, but the attribute doesn't" do
      @browser.div(:index, 1).id.should == ""
    end
    it "should raise UnknownObjectException if the element does not exist" do
      lambda {@browser.div(:id, "no_such_id").id }.should raise_error(UnknownObjectException)
      lambda {@browser.div(:title, "no_such_id").id }.should raise_error(UnknownObjectException)
      lambda {@browser.div(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#name" do
    it "should return the name attribute if the element exists" do
      @browser.div(:id, 'promo').name.should == "invalid_attribute"
    end
    it "should return an empty string if the element exists but the attribute doesn't" do
      @browser.div(:index, 1).name.should == ""
    end
    it "should raise UnknownObjectException if the element does not exist" do
      lambda {@browser.div(:id, "no_such_id").name }.should raise_error(UnknownObjectException)
      lambda {@browser.div(:title, "no_such_title").name }.should raise_error(UnknownObjectException)
      lambda {@browser.div(:index, 1337).name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#style" do
    it "should return the style attribute if the element exists" do
      @browser.div(:id, 'best_language').style.should == "color: red; text-decoration: underline; cursor: pointer;"
    end
    it "should return an empty string if the element exists but the attribute doesn't" do
      @browser.div(:id, 'promo').style.should == ""
    end
    it "should raise UnknownObjectException if the element does not exist" do
      lambda {@browser.div(:id, "no_such_id").style }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#text" do
    it "should return the text of the div" do
      @browser.div(:id, "footer").text.strip.should == "This is a footer."
      @browser.div(:title, "Closing remarks").text.strip.should == "This is a footer."
      @browser.div(:xpath, "//div[@id='footer']").text.strip.should == "This is a footer."
    end
    it "should return an empty string if the element exists but contains no text" do
      @browser.div(:index, 1).text.strip.should == ""
    end
    it "should raise UnknownObjectException if the element does not exist" do
      lambda { @browser.div(:id, "no_such_id").text }.should raise_error(UnknownObjectException)
      lambda { @browser.div(:title, "no_such_title").text }.should raise_error(UnknownObjectException)
      lambda { @browser.div(:index, 1337).text }.should raise_error(UnknownObjectException)
      lambda { @browser.div(:xpath, "//div[@id='no_such_id']").text }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#value" do
    it "should return the value attribute if the element exists" do
      @browser.div(:id, 'promo').value.should == "invalid_attribute"
    end
    it "should return an empty string if the element exists but the attribute doesn't" do
      @browser.div(:index, 1).value.should == ""
    end
    it "should raise UnknownObjectException if the element does not exist" do
      lambda {@browser.div(:id, "no_such_id").value }.should raise_error(UnknownObjectException)
      lambda {@browser.div(:title, "no_such_title").value }.should raise_error(UnknownObjectException)
      lambda {@browser.div(:index, 1337).value }.should raise_error(UnknownObjectException)
    end
  end
  
  # Manipulation methods
  describe "#click" do
    it "should fire events when clicked" do
      @browser.div(:id, 'best_language').text.should_not == 'Ruby!'
      @browser.div(:id, 'best_language').click
      @browser.div(:id, 'best_language').text.should == 'Ruby!'
    end
    it "should raise UnknownObjectException if the element does not exist" do
      lambda { @browser.div(:id, "no_such_id").click }.should raise_error(UnknownObjectException)
      lambda { @browser.div(:title, "no_such_title").click }.should raise_error(UnknownObjectException)
      lambda { @browser.div(:index, 1337).click }.should raise_error(UnknownObjectException)
      lambda { @browser.div(:xpath, "//div[@id='no_such_id']").click }.should raise_error(UnknownObjectException)
    end
  end

  describe "#html" do
    it "should return the HTML of the element" do
      html = @browser.div(:id, 'footer').html
      html.should include('<div id="footer" title="Closing remarks" class="profile">')
      html.should include('This is a footer.')
      html.should_not include('<div id="content">')
      html.should_not include('</body>')
    end
  end
  
  describe "#to_s" do
    it "should return a human readable representation of the element" do
      @browser.div(:id, 'footer').to_s.should == 
%q{tag:          div
  id:           footer
  title:        Closing remarks
  class:        profile
  text:         This is a footer.}
    end
  end
  
  after :all do
    @browser.close
  end

end

