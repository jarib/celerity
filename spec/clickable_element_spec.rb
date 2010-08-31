require File.expand_path("../watirspec/spec_helper", __FILE__)

describe "ClickableElement" do

  before :each do
    browser.goto(WatirSpec.files + "/non_control_elements.html")
  end

  describe "#click_and_attach" do
    it 'opens a page in a new browser with the same options' do
      b = browser.link(:name, /bad_attribute/).click_and_attach
      b.text.include?("User administration").should be_true # to make sure it is open.
      b.options.should == browser.options
      b.cookies.should == browser.cookies
    end

    it "opens the page in a new browser with the same cookies" do
      browser.add_cookie("localhost", "foo", "bar")
      old_cookies = browser.cookies
      old_cookies.should_not be_empty

      browser.goto(WatirSpec.files + "/non_control_elements.html")
      b = browser.link(:name, /bad_attribute/).click_and_attach

      b.should_not == browser
      b.cookies.should == old_cookies
    end
  end

  describe "#download" do
    it 'returns a click-opened page as io' do
      expected = File.read "#{WatirSpec.files}/forms_with_input_elements.html".sub("file://", '')

      browser.link(:name, /bad_attribute/).download.read.should == expected
      browser.link(:name, /bad_attribute/).should exist
    end
  end

end
