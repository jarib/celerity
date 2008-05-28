require File.dirname(__FILE__) + '/spec_helper.rb'

describe Li do
  
  before :all do
    @browser = IE.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/non_control_elements.html")
  end

  # Exists method
  describe "#exist?" do
    it "should return true if the 'li' exists" do
      @browser.li(:id, "non_link_1").should exist
      @browser.li(:id, /non_link_1/).should exist
      @browser.li(:text, "Non-link 3").should exist
      @browser.li(:text, /Non-link 3/).should exist
      @browser.li(:class, "nonlink").should exist
      @browser.li(:class, /nonlink/).should exist
      @browser.li(:index, 1).should exist
      @browser.li(:xpath, "//li[@id='non_link_1']").should exist
    end

    it "should return true if the element exists (default how = :id)" do
      @browser.li("non_link_1").should exist
    end

    it "should return false if the 'li' doesn't exist" do
      @browser.li(:id, "no_such_id").should_not exist
      @browser.li(:id, /no_such_id/).should_not exist
      @browser.li(:text, "no_such_text").should_not exist
      @browser.li(:text, /no_such_text/).should_not exist
      @browser.li(:class, "no_such_class").should_not exist
      @browser.li(:class, /no_such_class/).should_not exist
      @browser.li(:index, 1337).should_not exist
      @browser.li(:xpath, "//li[@id='no_such_id']").should_not exist
    end

    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.li(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end

    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.li(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#class_name" do
    it "should return the class attribute" do
      @browser.li(:id, 'non_link_1').class_name.should == 'nonlink'
    end

    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.li(:index, 1).class_name.should == ''
    end

    it "should raise UnknownObjectException if the li doesn't exist" do
      lambda { @browser.li(:id, 'no_such_id').class_name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#id" do
    it "should return the id attribute" do
      @browser.li(:class, 'nonlink').id.should == "non_link_1"
    end

    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.li(:index, 1).id.should == ''
    end

    it "should raise UnknownObjectException if the li doesn't exist" do
      lambda { @browser.li(:id, "no_such_id").id }.should raise_error(UnknownObjectException)
      lambda { @browser.li(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#title" do
    it "should return the title attribute" do
      @browser.li(:id, 'non_link_1').title.should == 'This is not a link!'
    end

    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.li(:index, 1).title.should == ''
    end

    it "should raise UnknownObjectException if the li doesn't exist" do
      lambda { @browser.li(:id, 'no_such_id').title }.should raise_error( UnknownObjectException)
      lambda { @browser.li(:xpath, "//li[@id='no_such_id']").title }.should raise_error( UnknownObjectException)
    end
  end
  
  describe "#text" do
    it "should return the text of the p" do
      @browser.li(:id, 'non_link_1').text.should == 'Non-link 1'
    end

    it "should return an empty string if the element doesn't contain any text" do
      @browser.li(:index, 1).text.should == ''
    end

    it "should raise UnknownObjectException if the li doesn't exist" do
      lambda { @browser.li(:id, 'no_such_id').text }.should raise_error( UnknownObjectException)
      lambda { @browser.li(:xpath , "//li[@id='no_such_id']").text }.should raise_error( UnknownObjectException)
    end
  end

  # Other
  describe "#to_s" do
    it "should return a human readable representation of the element" do
      @browser.li(:id, 'non_link_1').to_s.should == "tag:          li\n" + 
                                      "  id:           non_link_1\n" +
                                      "  class:        nonlink\n" +
                                      "  title:        This is not a link!\n" +
                                      "  text:         Non-link 1"
    end

    it "should raise UnknownObjectException if the li doesn't exist" do
      lambda { @browser.li(:xpath, "//li[@id='no_such_id']").to_s }.should raise_error( UnknownObjectException)
    end
  end
  
  after :all do
    @browser.close
  end

end