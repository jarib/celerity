describe IE do
  # class methods
  it "should respond to .speed"
  it "should respond to .speed="
  it "should respond to .set_fast_speed"
  it "should respond to .set_slow_speed"
  it "should respond to .attach_timeout"
  it "should respond to .attach_timeout="
  it "should respond to .reset_attach_timeout"
  it "should respond to .visible"
  it "should respond to .each"
  it "should respond to .quit"
  it "should alias .start_window to .start"
  
  # instance methods
  it "should respond to #visible"
  it "should respond to #visible="
  it "should respond to #wait"

  describe "#bring_to_front" do
    it "should return true" 
  end
end

describe Button do
  describe "#click_no_wait" do
    it "should behave like #click" 
  end
  
end

describe Link do
  describe "#click_no_wait" do
    it "should behave like #click" 
  end
end

  
describe Image do
  describe "#hasLoaded?" do
    it "should behave like #loaded?"
  end

  describe "#has_loaded?" do
    it "should behave like #loaded"
  end
  
  describe "#fileSize" do
    it "should behave like #file_size" 
  end
  
  describe "#fileCreatedDate" do
    it "should behave like #file_created_date"
  end
end

describe RadioCheckCommon do
  describe "#is_set?" do
    it "should behave like #set?" 
  end
  
  describe "#isSet?" do
    it "should behave like #set?"
  end

  describe "#get_state" do
    it "should behave like #set?"
  end

  describe "#getState" do
    it "should behave like #set?"
  end
  
end

describe SelectList do
  describe "#getSelectedItems" do
    it "should behave like #get_selected_items"
  end
  
  describe "#getAllContents" do
    it "should behave like #get_all_contents"
  end
  
  describe "#clearSelection" do
    it "should behave like #clear selection"
  end
  
  describe "#select_value" do
    it "should behave like #select" 
  end
end

describe TextField do
  describe "#dragContentsTo" do
    it "should behave like #drag_contents_to"
  end
  
  describe "#getContents" do
    it "should behave like #get_contents" 
  end
end
