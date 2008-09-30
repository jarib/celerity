require File.dirname(__FILE__) + '/spec_helper.rb'

describe "HtmlUnit bugs" do

  before :all do
    @browser = Browser.new
  end

  describe "HtmlUnit bug 1968686: https://sourceforge.net/tracker/index.php?func=detail&aid=1968686&group_id=47038&atid=448266" do
    it "should not raise NativeException: java.lang.StackOverflowError when going to a page where Javascripts prints a <body> tag inside another <body> tag" do
      lambda { @browser.goto(TEST_HOST + "/bug_javascript_001.html") }.should_not raise_error(NativeException)
    end
  end

  describe "HtmlUnit bug 1968708: https://sourceforge.net/tracker/index.php?func=detail&aid=1968708&group_id=47038&atid=448266" do
   it "should only consider the first attribute if there are duplicate attributes" do
     @browser.goto(TEST_HOST + "/bug_duplicate_attributes.html")
     @browser.text_field(:index, 1).id.should == "org_id"
   end
  end

  describe "HtmlUnit bug XXXXXX" do
    it "should return strings as UTF-8 when there's a charset mismatch between HTTP response header and <meta> tag" do
      @browser.goto(TEST_HOST + "/charset_mismatch")
      @browser.text.should == "\303\270"
    end
  end

  after :all do
    @browser.close
  end

end
