require File.dirname(__FILE__) + '/spec_helper.rb'

describe Pre do
  
  before :all do
    @browser = IE.new
    add_spec_checker(@browser)    
  end

  before :each do
    @browser.goto(TEST_HOST + "/non_control_elements.html")
  end

  # Exists method
  describe "#exist?" do
    it "should return true if the 'p' exists" do
      @browser.pre(:id, "rspec").should exist
      @browser.pre(:id, /rspec/).should exist
      @browser.pre(:text, '@browser.pre(:id, "rspec").should exist').should exist
      @browser.pre(:text, /@browser\.pre/).should exist
      @browser.pre(:class, "ruby").should exist
      @browser.pre(:class, /ruby/).should exist
      @browser.pre(:index, 1).should exist
      @browser.pre(:xpath, "//pre[@id='rspec']").should exist
    end
    it "should return true if the element exists (default how = :id)" do
      @browser.pre("rspec").should exist
    end
    it "should return false if the 'p' doesn't exist" do
      @browser.pre(:id, "no_such_id").should_not exist
      @browser.pre(:id, /no_such_id/).should_not exist
      @browser.pre(:text, "no_such_text").should_not exist
      @browser.pre(:text, /no_such_text/).should_not exist
      @browser.pre(:class, "no_such_class").should_not exist
      @browser.pre(:class, /no_such_class/).should_not exist
      @browser.pre(:index, 1337).should_not exist
      @browser.pre(:xpath, "//pre[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.pre(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.pre(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  # Attribute methods
  describe "#class_name" do
    it "should return the class attribute" do
      @browser.pre(:id, 'rspec').class_name.should == 'ruby'
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.pre(:index, 1).class_name.should == ''
    end
    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @browser.pre(:id, 'no_such_id').class_name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#id" do
    it "should return the id attribute" do
      @browser.pre(:class, 'ruby').id.should == "rspec"
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.pre(:index, 1).id.should == ''
    end
    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @browser.pre(:id, "no_such_id").id }.should raise_error(UnknownObjectException)
      lambda { @browser.pre(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#title" do
    it "should return the title attribute" do
      @browser.pre(:class, 'brainfuck').title.should == 'The brainfuck language is an esoteric programming language noted for its extreme minimalism'
    end
    it "should return an empty string if the element exists and the attribute doesn't" do
      @browser.pre(:index, 1).title.should == ''
    end
    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @browser.pre(:id, 'no_such_id').title }.should raise_error( UnknownObjectException)
      lambda { @browser.pre(:xpath, "//pre[@id='no_such_id']").title }.should raise_error( UnknownObjectException)
    end
  end
  
  describe "#text" do
    it "should return the text of the p" do
      @browser.pre(:class, 'haskell').text.should == 'main = putStrLn "Hello World"'
    end
    it "should return an empty string if the element doesn't contain any text" do
      @browser.pre(:index, 1).text.should == ''
    end
    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @browser.pre(:id, 'no_such_id').text }.should raise_error( UnknownObjectException)
      lambda { @browser.pre(:xpath , "//pre[@id='no_such_id']").text }.should raise_error( UnknownObjectException)
    end
  end

  # Other
  describe "#to_s" do
    it "should return a human readable representation of the element" do
      @browser.pre(:index, 1).to_s.should == "tag:          pre"
    end
    it "should raise UnknownObjectException if the p doesn't exist" do
      lambda { @browser.pre(:xpath, "//pre[@id='no_such_id']").to_s }.should raise_error( UnknownObjectException)
    end
  end
  
  after :all do
    @browser.close
  end

end