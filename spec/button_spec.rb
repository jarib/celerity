require File.expand_path("../watirspec/spec_helper", __FILE__)

describe "Button" do

  before :each do
    browser.goto(WatirSpec.files + "/forms_with_input_elements.html")
  end

  describe "#click_and_attach" do
    it "returns a new browser instance with the popup page" do
      b = browser.button(:name, 'new_popup_window').click_and_attach
      b.should_not == browser
      b.title.should == "Tables"
      browser.title.should == "Forms with input elements"
    end

    it "returns a new browser with same log_level as original" do
      b = browser.button(:name, 'new_popup_window').click_and_attach
      b.should_not == browser
      b.log_level.should == browser.log_level
    end
  end

end
