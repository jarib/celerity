require File.dirname(__FILE__) + '/spec_helper.rb'

describe IE do
  
  before :all do
    @browser = IE.new
    add_spec_checker(@browser)
  end
  
  # Exists
  describe "#exists?" do
    it "should return true if we are at a page" do
      @browser.should_not exist
      @browser.goto(TEST_HOST + "/non_control_elements.html")
      @browser.should exist
    end
    it "should return false after IE#close" do
      @browser.close
      @browser.should_not exist
    end
  end
  
  describe "#html" do
    it "should return the html of the page" do
      @browser.goto(TEST_HOST + "/non_control_elements.html")
      @browser.html.should == File.read(File.dirname(__FILE__) + "/html/non_control_elements.html")
    end
  end
  
  describe "#title" do
    it "should return the current page title" do
      @browser.goto(TEST_HOST + "/non_control_elements.html")
      @browser.title.should == "Non-control elements"
    end
  end

  describe "#text" do
    it "should return the text of the page" do
      @browser.goto(TEST_HOST + "/non_control_elements.html")
      @browser.text.should include("Dubito, ergo cogito, ergo sum.")
    end
    
    it "should return text in the correct charset (utf-8)" do
      # utf-8
      @browser.goto(TEST_HOST + "/utf8_text.html")
      @browser.text.strip.should == "\303\246\303\245\303\270"
    end
    
    it "should return text in the correct charset (latin-1)" do
      @browser.goto(TEST_HOST + "/latin1_text.html")
      @browser.text.strip.should == "\370\345\346"
    end
  end

  describe "#url" do
    it "should return the current url" do
      @browser.goto(TEST_HOST + "/non_control_elements.html")
      @browser.url.should == TEST_HOST + "/non_control_elements.html"
    end
  end
  
  describe "#document" do
    it "should return the underlying object" do
      @browser.goto(TEST_HOST + "/non_control_elements.html")
      if RUBY_PLATFORM =~ /java/
        @browser.document.should be_instance_of(Java::ComGargoylesoftwareHtmlunitHtml::HtmlHtml)
      else 
        @browser.document.should be_instance_of(WIN32OLE)
      end
    end
  end
  
  describe "#base_url" do
    it "should return the base URL of the current page" do
      @browser.goto(TEST_HOST + "/non_control_elements.html")
      @browser.base_url.should == "http://localhost" 
    end
  end
  
  
  # Manipulation methods
  describe ".start" do
    it "should go to the given URL and return an instance of itself" do
      @browser = Celerity::IE.start(TEST_HOST + "/non_control_elements.html")
      @browser.should be_instance_of(Celerity::IE)
      @browser.title.should == "Non-control elements"
    end
  end
  
  describe "#goto" do
    # waiting for JRuby OpenSSL
    # it "should handle HTTPS" do
    #   pending
    # end
    it "should go to the given url without raising errors" do
      lambda { @browser.goto(TEST_HOST + "/non_control_elements.html") }.should_not raise_error
    end
  end
  
  describe "#refresh" do
    it "should refresh the page" do
      @browser.goto(TEST_HOST + "/non_control_elements.html")
      @browser.span(:name, 'footer').click
      @browser.span(:name, 'footer').text.should include('Javascript')
      @browser.refresh
      @browser.span(:name, 'footer').text.should_not include('Javascript')
    end
  end
  
  describe "#execute_script" do
    it "should execute the given JavaScript on the current page" do
      @browser.goto(TEST_HOST + "/non_control_elements.html")
      @browser.pre(:id, 'rspec').text.should_not == "javascript text"
      @browser.execute_script("document.getElementById('rspec').innerHTML = 'javascript text'")
      @browser.pre(:id, 'rspec').text.should == "javascript text"
    end
  end
  
  describe "#back" do
    it "should go to the previous page" do
      @browser.goto(TEST_HOST + "/non_control_elements.html")
      orig_url = @browser.url
      @browser.goto(TEST_HOST + "/tables.html")
      new_url = @browser.url
      orig_url.should_not == new_url
      @browser.back
      orig_url.should == @browser.url
    end
  end
  
  # Other
  describe "#contains_text" do
    before :each do
      @browser.goto(TEST_HOST + "/non_control_elements.html")
    end

    it "should raise ArgumentError when called with no or wrong arguments" do
      lambda { @browser.contains_text }.should raise_error(ArgumentError)
      lambda { @browser.contains_text(nil) }.should raise_error(ArgumentError)
      lambda { @browser.contains_text(42) }.should raise_error(ArgumentError)
    end

    it "should return the index if the given text exists" do
        @browser.contains_text('Dubito, ergo cogito, ergo sum.').should be_instance_of(Fixnum)
        @browser.contains_text(/Dubito.*sum./).should_not be_nil
    end

    it "should return nil if the text doesn't exist" do
      @browser.contains_text('no_such_text').should be_nil
      @browser.contains_text(/no_such_text/).should be_nil
    end

    it "should not raise error on a blank page" do
      @browser = IE.new
      lambda { @browser.contains_text('') }.should_not raise_error
    end
  end
  
  describe "#add_checker" do
    it "should raise ArgumentError when not given any arguments" do
      lambda { @browser.add_checker }.should raise_error(ArgumentError)
    end
    it "should run the given proc on each page load" do
      output = ''
      proc = Proc.new { |ie| output << ie.text }
      @browser.add_checker(proc)
      @browser.goto(TEST_HOST + "/non_control_elements.html")
      output.should include('Dubito, ergo cogito, ergo sum')
    end
    it "should run the given block on each page load" do
      output = ''
      @browser.add_checker { |ie| output << ie.text }
      @browser.goto(TEST_HOST + "/non_control_elements.html")
      output.should include('Dubito, ergo cogito, ergo sum')
    end
  end
  
  describe "#disable_checker" do
    it "should remove a previously added checker" do
      output = ''
      checker = lambda { |ie| output << ie.text }
      @browser.add_checker(checker)
      @browser.goto(TEST_HOST + "/non_control_elements.html")
      output.should include('Dubito, ergo cogito, ergo sum')

      @browser.disable_checker(checker)
      @browser.goto(TEST_HOST + "/non_control_elements.html")
      output.should include('Dubito, ergo cogito, ergo sum')
    end
  end

  after :all do
    @browser.close
  end

end
