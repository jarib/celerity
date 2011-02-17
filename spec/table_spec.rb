# encoding: utf-8
require File.expand_path("../watirspec/spec_helper", __FILE__)

describe "Table" do

  before :each do
    browser.goto(WatirSpec.files + "/tables.html")
  end

  describe "#locate" do
    it "is not nil for existing tables" do
      browser.table(:id, 'axis_example').locate.should_not be_nil
    end
  end

  it "finds table data cells through #parent" do
    browser.span(:id => "cell-child").parent.should be_kind_of(Celerity::TableCell)
  end

  describe "#cells" do
    it "doesn't find cells in nested tables" do
      browser.table(:id => "outer").cells.length.should == 6
    end

    it "doesn't find cells in nested tables (for rows)" do
      browser.table(:id => "outer").row(:id => "outer_second").cells.length.should == 2
    end
  end

  describe "#tds" do
    it "doesn't find cells in nested tables" do
      browser.table(:id => "outer").tds.length.should == 6
    end

    it "doesn't find cells in nested tables (for rows)" do
      browser.table(:id => "outer").row(:id => "outer_second").tds.length.should == 2
    end
  end

end

