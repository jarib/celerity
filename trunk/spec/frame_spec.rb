require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Frame" do
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)
  end

  before :each do
   @ie.goto(TEST_HOST + "/frames.html")
  end
  
  it "should handle crossframe javascript" do
    @ie.frame(:id, "frame_1").text_field(:name, 'senderElement').value.should == 'send_this_value'
    @ie.frame(:id, "frame_2").text_field(:name, 'recieverElement').value.should == 'old_value'
    @ie.frame(:id, "frame_1").button(:id, 'send').click
    @ie.frame(:id, "frame_2").text_field(:name, 'recieverElement').value.should == 'send_this_value'
  end
  
  # Exists
  describe "#exist?" do
    it "should return true if the frame exists" do
      @ie.frame(:id, "frame_1").should exist
      @ie.frame(:id, /frame/).should exist
      @ie.frame(:name, "frame1").should exist
      @ie.frame(:name, /frame/).should exist
      @ie.frame(:src, "frame_1.html").should exist
      @ie.frame(:src, /frame_1/).should exist
      @ie.frame(:class, "half").should exist
      @ie.frame(:class, /half/).should exist
      @ie.frame(:index, 1).should exist
      @ie.frame(:xpath, "//frame[@id='frame_1']").should exist
    end
    it "should return true if the iframe exists" do
      @ie.goto(TEST_HOST + "/iframes.html")
      @ie.frame(:id, "frame_1").should exist
      @ie.frame(:id, /frame/).should exist
      @ie.frame(:name, "frame1").should exist
      @ie.frame(:name, /frame/).should exist
      @ie.frame(:src, "frame_1.html").should exist
      @ie.frame(:src, /frame_1/).should exist
      @ie.frame(:class, "iframe").should exist
      @ie.frame(:class, /iframe/).should exist
      @ie.frame(:index, 1).should exist
      @ie.frame(:xpath, "//iframe[@id='frame_1']").should exist
    end
    #TODO: default how = name
    it "should return false if the frame doesn't exist" do
      @ie.frame(:id, "no_such_id").should_not exist
      @ie.frame(:id, /no_such_id/).should_not exist
      @ie.frame(:name, "no_such_text").should_not exist
      @ie.frame(:name, /no_such_text/).should_not exist
      @ie.frame(:src, "no_such_src").should_not exist
      @ie.frame(:src, /no_such_src/).should_not exist
      @ie.frame(:class, "no_such_class").should_not exist
      @ie.frame(:class, /no_such_class/).should_not exist
      @ie.frame(:index, 1337).should_not exist
      @ie.frame(:xpath, "//frame[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when what argument is invalid" do
      lambda { @ie.frame(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when how argument is invalid" do
      lambda { @ie.frame(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  it "should raise UnknownFrameException when accessing elements inside non-existing frame" do
    lambda { @ie.frame(:name, "no_such_name").p(:index, 1).id }.should raise_error(UnknownFrameException)
  end
  it "should raise UnknownFrameException when accessing a non-existing frame" do
    lambda { @ie.frame(:name, "no_such_name").p(:index, 1).id }.should raise_error(UnknownFrameException)
  end
  it "should raise UnknownFrameException when accessing a non-existing subframe" do
    lambda { @ie.frame(:name, "frame1").frame(:name, "no_such_name").p(:index, 1).id }.should raise_error(UnknownFrameException)
  end
  it "should raise UnknownObjectException when accessing a non-existing element inside an existing frame" do
    lambda { @ie.frame(:index, 1).p(:index, 1337).id }.should raise_error(UnknownObjectException)
  end
  it "should be able to send a value to another frame by using Javascript" do
  end
  
  describe "#contains_text" do
    it "should find text in a frame" do
      @ie.frame(:name, 'frame1').contains_text('Suspendisse sit amet nisi.').should be_instance_of(Fixnum)
    end
    it "should raise ArgumentError when given an invalid argument" do
      lambda { @ie.frame(:name, 'frame1').contains_text(3.14) }.should raise_error(ArgumentError)
    end
  end
  
  describe "#to_s" do
    it "should return a human readable representation of the frame" do
      @ie.frame(:index, 1).to_s.should == "tag:          frame\n" +
                                          "  src:          frame_1.html\n" +
                                          "  id:           frame_1\n" +
                                          "  name:         frame1\n" +
                                          "  class:        half"
    end
  end
  
end

