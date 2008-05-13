require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Image" do

  before :all do
    @ie = IE.new
    add_spec_checker(@ie)
  end

  before :each do
    @ie.goto(TEST_HOST + "/images.html")
  end

  # Exists method
  describe "#exists" do
    it "should return true when the image exists" do
      @ie.image(:id, 'square').should exist
      @ie.image(:id, /square/).should exist
      @ie.image(:name, 'circle').should exist
      @ie.image(:name, /circle/).should exist
      @ie.image(:src, 'images/circle.jpg').should exist
      @ie.image(:src, /circle/).should exist
      @ie.image(:alt, 'circle').should exist
      @ie.image(:alt, /cir/).should exist
      @ie.image(:title, 'Circle').should exist
    end
    it "should return false when the image exists" do
      @ie.image(:id, 'no_such_id').should_not exist
      @ie.image(:id, /no_such_id/).should_not exist
      @ie.image(:name, 'no_such_name').should_not exist
      @ie.image(:name, /no_such_name/).should_not exist
      @ie.image(:src, 'no_such_src').should_not exist
      @ie.image(:src, /no_such_src/).should_not exist
      @ie.image(:alt, 'no_such_alt').should_not exist
      @ie.image(:alt, /no_such_alt/).should_not exist
      @ie.image(:title, 'no_such_title').should_not exist
      @ie.image(:title, /no_such_title/).should_not exist
    end
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @ie.button(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @ie.button(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end

  # Attribute methods
  describe "#alt" do
    it "should return the alt attribute of the image if the image exists" do
      @ie.image(:name, 'square').alt.should == "square"
      @ie.image(:name, 'circle').alt.should == 'circle'
    end
    it "should return an empty string if the image exists and the attribute doesn't" do
      @ie.image(:index, 1).alt.should == ""
    end
    it "should raise UnknownObjectException if the image doesn't exist" do
      lambda { @ie.image(:index, 1337).alt }.should raise_error(UnknownObjectException)
    end
  end

  describe "#id" do
    it "should return the id attribute of the image if the image exists" do
      @ie.image(:name, 'square').id.should == 'square'
    end
    it "should return an empty string if the image exists and the attribute doesn't" do
      @ie.image(:index, 1).id.should == ""
    end
    it "should raise UnknownObjectException if the image doesn't exist" do
      lambda { @ie.image(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end

  describe "#name" do
    it "should return the name attribute of the image if the image exists" do
      @ie.image(:name, 'square').name.should == 'square'
    end
    it "should return an empty string if the image exists and the attribute doesn't" do
      @ie.image(:index, 1).name.should == ""
    end
    it "should raise UnknownObjectException if the image doesn't exist" do
      lambda { @ie.image(:index, 1337).name }.should raise_error(UnknownObjectException)
    end
  end

  describe "#src" do
    it "should return the src attribute of the image if the image exists" do
      @ie.image(:name, 'square').src.should match(/square\.jpg/i)
    end
    it "should return an empty string if the image exists and the attribute doesn't" do
      @ie.image(:index, 1).src.should == ""
    end
    it "should raise UnknownObjectException if the image doesn't exist" do
      lambda { @ie.image(:index, 1337).src }.should raise_error(UnknownObjectException)
    end
  end

  describe "#title" do
    it "should return the title attribute of the image if the image exists" do
      @ie.image(:id, 'square').title.should == 'Square'
    end
    it "should return an empty string if the image exists and the attribute doesn't" do
      @ie.image(:index, 1).title.should == ""
    end
    it "should raise UnknownObjectException if the image doesn't exist" do
      lambda { @ie.image(:index, 1337).title }.should raise_error(UnknownObjectException)
    end
  end

  # Manipulation methods
  describe "#click" do
    it "should raise UnknownObjectException when the image doesn't exist" do
      lambda { @ie.image(:id, 'missing_attribute').click }.should raise_error(UnknownObjectException)
      lambda { @ie.image(:name, 'missing_attribute').click }.should raise_error(UnknownObjectException)
      lambda { @ie.image(:src, 'missing_attribute').click }.should raise_error(UnknownObjectException)
      lambda { @ie.image(:alt, 'missing_attribute').click }.should raise_error(UnknownObjectException)
    end
  end

  # File methods
  describe "#file_created_date" do
    it "should return the date the image was created as reported by the file system" do
      image = @ie.image(:index, 2)
      path = File.dirname(__FILE__) + "/html/#{image.src}"
      image.file_created_date.to_i.should == File.mtime(path).to_i
    end
  end

  describe "#file_size" do
    it "should return the file size of the image if the image exists" do
      @ie.image(:id, 'square').file_size.should == 788
    end
    it "should raise UnknownObjectException if the image doesn't exist" do
      lambda { @ie.image(:index, 1337).file_size }.should raise_error(UnknownObjectException)
    end
  end

  describe "#height" do
    it "should return the height of the image if the image exists" do
      @ie.image(:id, 'square').height.should == 88
    end
    it "should raise UnknownObjectException if the image doesn't exist" do
      lambda { @ie.image(:index, 1337).height }.should raise_error(UnknownObjectException)
    end
  end

  describe "#width" do
    it "should return the width of the image if the image exists" do
      @ie.image(:id, 'square').width.should == 88
    end
    it "should raise UnknownObjectException if the image doesn't exist" do
      lambda { @ie.image(:index, 1337).width }.should raise_error(UnknownObjectException)
    end
  end

  # Other
  describe "#loaded?" do
    it "should return true if the image has been loaded" do
      @ie.image(:name, 'circle').should be_loaded
      @ie.image(:alt, 'circle').should be_loaded
      @ie.image(:alt, /circle/).should be_loaded
    end
    it "should return false if the image has not been loaded" do
      @ie.image(:id, 'no_such_file').should_not be_loaded
    end
    it "should raise UnknownObjectException if the image doesn't exist" do
      lambda { @ie.image(:name, 'no_such_image').loaded? }.should raise_error(UnknownObjectException)
      lambda { @ie.image(:id, 'no_such_image').loaded? }.should raise_error(UnknownObjectException)
      lambda { @ie.image(:src, 'no_such_image').loaded? }.should raise_error(UnknownObjectException)
      lambda { @ie.image(:alt, 'no_such_image').loaded? }.should raise_error(UnknownObjectException)
      lambda { @ie.image(:index, 1337).loaded? }.should raise_error(UnknownObjectException)
    end
  end

  describe "#html" do
    it "should return the image element as a string of html" do
      @ie.image(:id, 'triangle').html.chomp.should == '<img src="images/triangle.jpg" id="triangle" usemap="#triangle_map" />'
    end
  end

  describe "#save" do
    it "should save an image to file" do
      file = "sample.img.dat"
      @ie.image(:index, 2).save(file)
      File.exist?(file).should be_true
      File.delete(file)
    end
  end

  after :all do
    @ie.close
  end

end
