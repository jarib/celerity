require File.dirname(__FILE__) + '/spec_helper.rb'

describe Frame do
  before :all do
    @browser = IE.new
  end

  before :each do
   @browser.goto(TEST_HOST + "/frames.html")
  end
  
  it "should handle crossframe javascript" do
    @browser.frame(:id, "frame_1").text_field(:name, 'senderElement').value.should == 'send_this_value'
    @browser.frame(:id, "frame_2").text_field(:name, 'recieverElement').value.should == 'old_value'
    @browser.frame(:id, "frame_1").button(:id, 'send').click
    @browser.frame(:id, "frame_2").text_field(:name, 'recieverElement').value.should == 'send_this_value'
  end
  
  # Exists
  describe "#exist?" do
    it "should return true if the frame exists" do
      @browser.frame(:id, "frame_1").should exist
      @browser.frame(:id, /frame/).should exist
      @browser.frame(:name, "frame1").should exist
      @browser.frame(:name, /frame/).should exist
      @browser.frame(:src, "frame_1.html").should exist
      @browser.frame(:src, /frame_1/).should exist
      @browser.frame(:class, "half").should exist
      @browser.frame(:class, /half/).should exist
      @browser.frame(:index, 1).should exist
      @browser.frame(:xpath, "//frame[@id='frame_1']").should exist
    end
    it "should return true if the iframe exists" do
      @browser.goto(TEST_HOST + "/iframes.html")
      @browser.frame(:id, "frame_1").should exist
      @browser.frame(:id, /frame/).should exist
      @browser.frame(:name, "frame1").should exist
      @browser.frame(:name, /frame/).should exist
      @browser.frame(:src, "frame_1.html").should exist
      @browser.frame(:src, /frame_1/).should exist
      @browser.frame(:class, "iframe").should exist
      @browser.frame(:class, /iframe/).should exist
      @browser.frame(:index, 1).should exist
      @browser.frame(:xpath, "//iframe[@id='frame_1']").should exist
    end
    it "should return true if the element exists (default how = :name)" do
      @browser.frame("frame1").should exist
      @browser.goto(TEST_HOST + "/iframes.html")
      @browser.frame("frame1").should exist
    end
    it "should return false if the frame doesn't exist" do
      @browser.frame(:id, "no_such_id").should_not exist
      @browser.frame(:id, /no_such_id/).should_not exist
      @browser.frame(:name, "no_such_text").should_not exist
      @browser.frame(:name, /no_such_text/).should_not exist
      @browser.frame(:src, "no_such_src").should_not exist
      @browser.frame(:src, /no_such_src/).should_not exist
      @browser.frame(:class, "no_such_class").should_not exist
      @browser.frame(:class, /no_such_class/).should_not exist
      @browser.frame(:index, 1337).should_not exist
      @browser.frame(:xpath, "//frame[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.frame(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.frame(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  it "should raise UnknownFrameException when accessing elements inside non-existing frame" do
    lambda { @browser.frame(:name, "no_such_name").p(:index, 1).id }.should raise_error(UnknownFrameException)
  end
  it "should raise UnknownFrameException when accessing a non-existing frame" do
    lambda { @browser.frame(:name, "no_such_name").p(:index, 1).id }.should raise_error(UnknownFrameException)
  end
  it "should raise UnknownFrameException when accessing a non-existing subframe" do
    lambda { @browser.frame(:name, "frame1").frame(:name, "no_such_name").p(:index, 1).id }.should raise_error(UnknownFrameException)
  end
  it "should raise UnknownObjectException when accessing a non-existing element inside an existing frame" do
    lambda { @browser.frame(:index, 1).p(:index, 1337).id }.should raise_error(UnknownObjectException)
  end
  it "should be able to send a value to another frame by using Javascript" do
    frame1, frame2 = @browser.frame(:index, 1), @browser.frame(:index, 2)
    frame1.text_field(:index, 1).value.should == "send_this_value"
    frame2.text_field(:index, 1).value.should == "old_value"
    frame1.button(:index, 1).click
    frame2.text_field(:index, 1).value.should == "send_this_value"
  end
  
  describe "#contains_text" do
    it "should find text in a frame" do
      @browser.frame(:name, 'frame1').contains_text('Suspendisse sit amet nisi.').should be_instance_of(Fixnum)
    end
    it "should raise ArgumentError when given an invalid argument" do
      lambda { @browser.frame(:name, 'frame1').contains_text(3.14) }.should raise_error(ArgumentError)
    end
  end
  
  describe "#to_s" do
    it "should return a human readable representation of the frame" do
      @browser.frame(:index, 1).to_s.should == "tag:          frame\n" +
                                          "  src:          frame_1.html\n" +
                                          "  id:           frame_1\n" +
                                          "  name:         frame1\n" +
                                          "  class:        half"
    end
  end
  
end

