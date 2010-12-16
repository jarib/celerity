# encoding: utf-8
require File.expand_path("../watirspec/spec_helper", __FILE__)

describe "Element" do

  before :each do
    browser.goto(WatirSpec.files + "/forms_with_input_elements.html")
  end

  describe "#identifier_string" do
    it "doesn't make the next locate find the wrong element" do
      elem = browser.div(:id, 'hidden_parent')
      elem.should exist
      elem.__send__(:identifier_string)
      elem.id.should == 'hidden_parent'
    end

    it "uses the user specified identifier_string if one is present" do
      elem = browser.div(:id, 'hidden_parent')
      elem.identifier_string = "this is it"
      elem.__send__(:identifier_string).should == "this is it"
    end
  end

  describe "#method_missing" do
    it "magically returns the requested attribute if the attribute is defined in the attribute list" do
      browser.form(:index, Celerity.index_offset).action.should == 'post_to_me'
    end

    it "raises NoMethodError if the requested method isn't among the attributes" do
      lambda { browser.button(:index, Celerity.index_offset).no_such_attribute_or_method }.should raise_error(NoMethodError)
    end
  end

  describe "#xpath" do
    it "gets the canonical xpath of this element" do
      browser.text_field(:id, "new_user_email").xpath.should == '/html/body/form[1]/fieldset[1]/input[3]'
    end
  end

  describe "#javascript_object" do
    it "should return the JavaScript object representing the receiver" do
      obj = browser.div(:id, "onfocus_test").javascript_object
      obj.should be_kind_of(com.gargoylesoftware.htmlunit.javascript.host.html.HTMLElement)
      obj.should be_instance_of(com.gargoylesoftware.htmlunit.javascript.host.html.HTMLDivElement)
      obj.client_width.should be_kind_of(Integer)
    end
  end

  describe "#locate" do
    it "raises ArgumentError when used with :object and the object given isn't an HtmlElement subclass" do
      lambda { Link.new(browser, :object, "foo").locate }.should raise_error(ArgumentError)
    end
  end

  describe "#focused?" do
    it "returns true if the element has focus" do
      tf = browser.text_field(:id, "delete_user_comment")
      tf.should_not be_focused

      tf.focus
      tf.should be_focused
    end

  end

  describe "#==" do
    it "returns true if passed the same element" do
      browser.label(:id, 'first_label').should == browser.labels.first
    end

    it "returns false if passed a different element" do
      browser.label(:id, 'first_label').should_not == browser.labels.last
    end
  end

end
