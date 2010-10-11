require File.expand_path("../watirspec/spec_helper", __FILE__)

describe "HtmlUnit bugs" do
  describe "HtmlUnit bug 1968686: https://sourceforge.net/tracker/index.php?func=detail&aid=1968686&group_id=47038&atid=448266" do
    it "does not raise NativeException: java.lang.StackOverflowError when going to a page where Javascripts prints a <body> tag inside another <body> tag" do
      lambda { browser.goto(WatirSpec.files + "/bug_javascript_001.html") }.should_not raise_error(NativeException)
    end
  end

  describe "HtmlUnit bug 1968708: https://sourceforge.net/tracker/index.php?func=detail&aid=1968708&group_id=47038&atid=448266" do
   it "only considers the first attribute if there are duplicate attributes" do
     browser.goto(WatirSpec.files + "/bug_duplicate_attributes.html")
     browser.text_field(:index, Celerity.index_offset).id.should == "org_id"
   end
  end

  describe "NekoHtml parser bug: https://sourceforge.net/tracker/?func=detail&aid=2824922&group_id=47038&atid=448266" do
    it "does not run out of java heap space" do
      lambda { browser.goto(WatirSpec.files + "/parser_bug_001.html") }.should_not raise_error
    end
  end

# disabled for CI - need fix from HtmlUnit
  # describe "HtmlUnit bug XXXXXX" do
  #   it "returns strings as UTF-8 when there's a charset mismatch between HTTP response header and <meta> tag" do
  #     browser.goto(WatirSpec.host + "/charset_mismatch")
  #     browser.h1(:index, 1).text.should == "\303\270"
  #   end
  # end

  it "evaluates <script> tags injected in the DOM through JQuery's replaceWith() - fixed in rev. 3598" do
    browser.goto(WatirSpec.files + "/jquery.html")
    browser.link(:class, 'editLink').click
    browser.div(:id, 'content').text.should == "typeof update: function"
  end

  it "doesn't return the TinyMCE DOM when executing javascript functions" do
    b = WatirSpec.new_browser

    b.goto(WatirSpec.files + "/tiny_mce.html")
    b.text.should include("Beskrivelse")
    b.checkbox(:id, "exemption").set
    b.text.should include("Beskrivelse")

    b.close
  end

  describe "HtmlUnit bug 2811607: https://sourceforge.net/tracker/?func=detail&aid=2811607&group_id=47038&atid=448266" do
    it "correctly prevents default on <form>#submit()" do
      browser.goto(WatirSpec.files + "/prevent_form_submit.html")
      browser.button(:id, "next").click
      browser.title.should == "preventDefault() on form submission"
    end
  end

  describe "HtmlUnit bug 2974355: https://sourceforge.net/tracker/index.php?func=detail&aid=2974355&group_id=47038&atid=448266" do
    it "accesses pages with characters in URI that need encoding" do
      browser.goto(WatirSpec.host + '/encodable_%3Cstuff%3E')
      browser.text.should include('page with characters in URI that need encoding')
    end
  end

end
