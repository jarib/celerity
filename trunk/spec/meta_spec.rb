require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Meta" do

  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
  end

  describe "#exist?" do
    it "should return true if the meta tag exists" do
      @browser.meta('http-equiv', "Content-Type").should exist
    end
  end

  describe "content" do
    it "should return the content attribute of the tag" do
      @browser.meta('http-equiv', "Content-Type").content.should == "text/html; charset=utf-8"
    end
  end
  after :all do
    @browser.close
  end

end

