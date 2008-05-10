require File.dirname(__FILE__) + '/spec_helper.rb'

describe "IE" do
  
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)
  end
  
  # Exists
  describe "#exists?" do
    it "should return true if we are at a page" do
      @ie.should_not exist
      @ie.goto(TEST_HOST + "/non_control_elements.html")
      @ie.should exist
    end
    it "should return false after IE#close" do
      @ie.close
      @ie.should_not exist
    end
  end
  
  # Attribute methods
  describe "#html" do
    it "should return the html of the page" do
      @ie.goto(TEST_HOST + "/non_control_elements.html")
      @ie.html.should include('<meta http-equiv="Content-Type"')
    end
  end
  
  describe "#title" do
    it "should return the current page title" do
      @ie.goto(TEST_HOST + "/non_control_elements.html")
      @ie.title.should == "Non-control elements"
    end
  end

  describe "#text" do
    it "should return the text of the page" do
      @ie.goto(TEST_HOST + "/non_control_elements.html")
      @ie.text.include?("Dubito, ergo cogito, ergo sum.").should be_true
    end
  end

  describe "#url" do
    it "should return the current url" do
      @ie.goto(TEST_HOST + "/non_control_elements.html")
      @ie.url.should == TEST_HOST + "/non_control_elements.html"
    end
  end
  
  
  # Manipulation methods
  describe ".start" do
    it "should go to the given URL and return an instance of itself" do
      @ie = Celerity::IE.start(TEST_HOST + "/non_control_elements.html")
      @ie.should be_instance_of(Celerity::IE)
      @ie.title.should == "Non-control elements"
    end
  end
  
  describe "#goto" do
    it "should go to the given url without raising errors" do
      lambda { @ie.goto(TEST_HOST + "/non_control_elements.html") }.should_not raise_error
    end
  end
  
  describe "#refresh" do
    it "should refresh the page" do
      @ie.refresh
    end
  end
  
  describe "#back" do
    it "should go to the previous page" do
      @ie.goto(TEST_HOST + "/non_control_elements.html")
      orig_url = @ie.url
      @ie.goto(TEST_HOST + "/tables.html")
      new_url = @ie.url
      orig_url.should_not == new_url
      @ie.back
      orig_url.should == @ie.url
    end
  end
  
  # Other
  describe "#contains_text" do
    before :each do
      @ie.goto(TEST_HOST + "/non_control_elements.html")
    end

    it "should raise ArgumentError when called with no or wrong arguments" do
      lambda { @ie.contains_text }.should raise_error(ArgumentError)
      lambda { @ie.contains_text(nil) }.should raise_error(ArgumentError)
      lambda { @ie.contains_text(42) }.should raise_error(ArgumentError)
    end

    it "should return the index if the given text exists" do
        @ie.contains_text('Dubito, ergo cogito, ergo sum.').should be_instance_of(Fixnum)
        @ie.contains_text(/Dubito.*sum./).should_not be_nil
    end

    it "should return nil if the text doesn't exist" do
      @ie.contains_text('no_such_text').should be_nil
      @ie.contains_text(/no_such_text/).should be_nil
    end

    it "should not raise error on a blank page" do
      @ie = IE.new
      lambda { @ie.contains_text('') }.should_not raise_error
    end
  end
  
  describe "#add_checker" do
    it "should raise ArgumentError when not given any arguments" do
      lambda { @ie.add_checker }.should raise_error(ArgumentError)
    end
    it "should run the given proc on each page load" do
      output = ''
      @ie.add_checker(Proc.new { |ie| output << ie.text })
      @ie.goto(TEST_HOST + "/non_control_elements.html")
      output.should include('Dubito, ergo cogito, ergo sum')
    end
    it "should run the given block on each page load" do
      output = ''
      @ie.add_checker { |ie| output << ie.text }
      @ie.goto(TEST_HOST + "/non_control_elements.html")
      output.should include('Dubito, ergo cogito, ergo sum')
    end
  end
  
  describe "#disable_checker" do
    it "should remove a previously added checker" do
      output = ''
      checker = lambda { |ie| output << ie.text }
      @ie.add_checker(checker)
      @ie.goto(TEST_HOST + "/non_control_elements.html")
      output.should include('Dubito, ergo cogito, ergo sum')

      @ie.disable_checker(checker)
      @ie.goto(TEST_HOST + "/non_control_elements.html")
      output.should include('Dubito, ergo cogito, ergo sum')
    end
  end

  after :all do
    @ie.close
  end

end
