# encoding: utf-8
require File.expand_path("../watirspec/spec_helper", __FILE__)

describe "Link" do

  before :each do
    browser.goto(WatirSpec.files + "/non_control_elements.html")
  end

  describe "absolute_url" do
    it "returns the absolute URL for a link with a relative href attribute" do
      browser.link(:index, Celerity.index_offset + 1).absolute_url.should include("#{WatirSpec.files}/non_control_elements.html".gsub("file://", ''))
    end
  end

end
