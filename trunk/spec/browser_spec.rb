require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Browser" do

  before :all do
    @browser = Browser.new
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

    it "should return the text also if the content-type is text/plain" do
      # more specs for text/plain? what happens if we call other methods?
      @browser.goto(TEST_HOST + "/plain_text")
      @browser.text.strip.should == 'This is text/plain'
    end

    it "should return a text representation including newlines" do
      @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
      @browser.text.should == <<-TEXT
Forms with input elementsUser administration

Add user

Personal informationFirst name

Last name

Email address

Country  Denmark Norway Sweden United Kingdom USA

Occupation

Species

Personal code

Languages  Danish English Norwegian Swedish

Portrait

Dental records   Login informationUsername (max 20 characters)  0

Password

Role  Administrator Moderator Regular user  Interests Books  Bowling  Cars  Dancing  Dentistry   Food  Preferences

Do you want to recieve our newslettter?

 Yes  No  Certainly  Absolutely  Nah  Actions  Button 2

Delete user

Username  Username 1 Username 2 Username 3

Comment Default comment.
TEXT
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

  # Manipulation methods
  describe ".start" do
    it "should go to the given URL and return an instance of itself" do
      @browser = Browser.start(TEST_HOST + "/non_control_elements.html")
      @browser.should be_instance_of(Browser)
      @browser.title.should == "Non-control elements"
    end
  end

  describe "#goto" do
    it "should add http:// to URLs with no protocol specified" do
      url = TEST_HOST[%r{http://(.*)}, 1]
      url.should_not be_nil
      @browser.goto(url)
      @browser.url.should =~ %r[http://#{url}/?]
    end

    it "should go to the given url without raising errors" do
      lambda { @browser.goto(TEST_HOST + "/non_control_elements.html") }.should_not raise_error
    end

    it "should raise UnexpectedPageException if the content type is not understood" do
      lambda { @browser.goto(TEST_HOST + "/octet_stream") }.should raise_error(UnexpectedPageException)
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

  describe "#wait_while" do
    it "should return after the condition becomes false" do
      pending
    end
  end

  describe "#wait_until" do
    it "should return after the condition becomes true" do
      pending
    end
  end

  # Other
  describe "#contains_text" do
    before :each do
      @browser.goto(TEST_HOST + "/non_control_elements.html")
    end

    it "should raise ArgumentError when called with no arguments" do
      lambda { @browser.contains_text }.should raise_error(ArgumentError)
    end

    it "should raise TypError when called with wrong arguments" do
      lambda { @browser.contains_text(nil) }.should raise_error(TypeError)
      lambda { @browser.contains_text(42) }.should raise_error(TypeError)
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
      @browser = Browser.new
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

  it "should raise UnknownObjectException when trying to access DOM elements on plain/text-page" do
    @browser.goto(TEST_HOST + "/plain_text")
    lambda { @browser.div(:id, 'foo').id }.should raise_error(UnknownObjectException)
  end


  after :all do
    @browser.close
  end

end
