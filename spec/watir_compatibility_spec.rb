require File.dirname(__FILE__) + '/spec_helper.rb'

describe "IE" do

  before :each do
    @browser = Browser.new
  end

  # Class methods
  it "should respond to .speed" do
    Browser.should respond_to("speed")
  end

  it "should respond to .speed=" do
    Browser.should respond_to("speed=")
  end

  it "should respond to .set_fast_speed" do
    Browser.should respond_to("set_fast_speed")
  end

  it "should respond to .set_slow_speed" do
    Browser.should respond_to("set_slow_speed")
  end

  it "should respond to .attach_timeout" do
    Browser.should respond_to("attach_timeout")
  end

  it "should respond to .attach_timeout=" do
    Browser.should respond_to("attach_timeout=")
  end

  it "should respond to .reset_attach_timeout" do
    Browser.should respond_to("reset_attach_timeout")
  end

  it "should respond to .visible" do
    Browser.should respond_to("visible")
  end

  it "should respond to .each" do
    Browser.should respond_to("each")
  end

  it "should respond to .quit" do
    Browser.should respond_to("quit")
  end

  it "should alias .start_window to .start" do
    Browser.should respond_to("start")
  end

  # Instance methods
  it "should respond to #visible" do
    @browser.should respond_to("visible")
  end

  it "should respond to #visible=" do
    @browser.should respond_to("visible=")
  end

  it "should respond to #wait" do
    @browser.should respond_to("wait")
  end

  describe "#bring_to_front" do
    it "should return true" do
      @browser.bring_to_front.should be_true
    end
  end

  describe "#checkBox" do
    it "should behave like #checkbox" do
      @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
      @browser.checkbox(:id, "new_user_interests_books").should exist
      @browser.checkbox(:id, "new_user_interests_cars").should_not be_set
      @browser.checkbox(:id, "new_user_interests_cars").set
      @browser.checkbox(:id, "new_user_interests_cars").should be_set
    end
  end

end

describe "Button" do

  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
  end

  describe "#click_no_wait" do
    it "should behave like #click" do
      @browser.button(:id, 'new_user_submit').click_no_wait
      @browser.text.should include("You posted the following content:")
    end
  end

end

describe "Link" do

  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/non_control_elements.html")
  end

  describe "#click_no_wait" do
    it "should behave like #click" do
      @browser.link(:text, "Link 3").click_no_wait
      @browser.text.include?("User administration").should be_true
    end
  end

end

describe "Image" do

  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/images.html")
  end

  describe "#hasLoaded?" do
    it "should behave like #loaded?" do
      @browser.image(:name, 'circle').hasLoaded?.should be_true
    end
  end

  describe "#has_loaded?" do
    it "should behave like #loaded" do
      @browser.image(:name, 'circle').has_loaded?.should be_true
    end
  end

  describe "#fileSize" do
    it "should behave like #file_size" do
      @browser.image(:id, 'square').fileSize.should == 788
    end
  end

  describe "#fileCreatedDate" do
    it "should behave like #file_created_date" do
      image = @browser.image(:index, 2)
      path = File.dirname(__FILE__) + "/html/#{image.src}"
      image.file_created_date.to_i.should == File.mtime(path).to_i
    end
  end

end

describe "RadioCheckCommon" do
  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
  end

  describe "#is_set?" do
    it "should behave like #set?" do
      @browser.radio(:id, "new_user_newsletter_yes").is_set?.should be_true
    end
  end

  describe "#isSet?" do
    it "should behave like #set?" do
      @browser.radio(:id, "new_user_newsletter_yes").isSet?.should be_true
    end
  end

  describe "#get_state" do
    it "should behave like #set?" do
      @browser.checkbox(:id, "new_user_interests_books").get_state.should be_true
    end
  end

  describe "#getState" do
    it "should behave like #set?" do
      @browser.checkbox(:id, "new_user_interests_books").getState.should be_true
    end
  end

end

describe "SelectList" do

  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
  end

  describe "#getSelectedItems" do
    it "should behave like #selected_options" do
      @browser.select_list(:name, "new_user_country").getSelectedItems.should == ["Norway"]
      @browser.select_list(:name, "new_user_languages").getSelectedItems.should == ["English", "Norwegian"]
    end
  end

  describe "#getAllContents" do
    it "should behave like #options" do
      @browser.select_list(:name, "new_user_country").getAllContents.should == ["Denmark" ,"Norway" , "Sweden" , "United Kingdom", "USA"]
    end
  end

  describe "#clearSelection" do
    it "should behave like #clear_selection" do
      @browser.select_list(:name, "new_user_languages").clearSelection
      @browser.select_list(:name, "new_user_languages").getSelectedItems.should be_empty
    end
  end

  describe "#select_value" do
    it "should behave like #select" do
      @browser.select_list(:name, "new_user_country").select_value("Denmark")
      @browser.select_list(:name, "new_user_country").getSelectedItems.should == ["Denmark"]
    end
  end

end

describe "TextField" do

  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
  end

  describe "#dragContentsTo" do
    it "should behave like #drag_contents_to" do
      @browser.text_field(:name, "new_user_first_name").set("Smith")
      @browser.text_field(:name, "new_user_first_name").dragContentsTo(:name, "new_user_last_name")
      @browser.text_field(:name, "new_user_first_name").value.should be_empty
      @browser.text_field(:id, "new_user_last_name").value.should == "Smith"
    end
  end

  describe "#getContents" do
    it "should behave like #get_contents" do
      @browser.text_field(:name, "new_user_occupation").getContents.should == "Developer"
    end
  end

end