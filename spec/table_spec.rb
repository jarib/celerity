# encoding: utf-8
require File.dirname(__FILE__) + '/watirspec/spec_helper'

describe "Table" do

  before :each do
    browser.goto(WatirSpec.files + "/tables.html")
  end

  describe "#locate" do
    it "is not nil for existing tables" do
      browser.table(:id, 'axis_example').locate.should_not be_nil
    end
  end
  
end

