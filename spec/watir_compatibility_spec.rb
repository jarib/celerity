require File.expand_path("../watirspec/spec_helper", __FILE__)

describe "Button" do

  before :each do
    browser.goto(WatirSpec.host + "/forms_with_input_elements.html")
  end

  describe "#click_no_wait" do
    it "behaves like #click" do
      browser.button(:id, 'new_user_submit').click_no_wait
      browser.text.should include("You posted the following content:")
    end
  end

end

describe "Link" do

  before :each do
    browser.goto(WatirSpec.host + "/non_control_elements.html")
  end

  describe "#click_no_wait" do
    it "behaves like #click" do
      browser.link(:text, "Link 3").click_no_wait
      browser.text.include?("User administration").should be_true
    end
  end

end

