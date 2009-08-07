require File.dirname(__FILE__) + '/watirspec/spec_helper'

describe "Browser" do

  describe "#credentials=" do
    it "sets the basic authentication credentials" do
      browser.goto(WatirSpec.host + "/authentication")
      browser.text.should_not include("ok")

      browser.credentials = "foo:bar"

      browser.goto(WatirSpec.host + "/authentication")
      browser.text.should include("ok")
    end
  end
end
