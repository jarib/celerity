require File.dirname(__FILE__) + '/spec_helper.rb'

describe "FileField" do
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  
  # Exist method
  
  describe "#exist?" do
    it "should return true if the file field exists" do
      @ie.file_field(:id, 'new_user_portrait').should exist
      @ie.file_field(:id, /new_user_portrait/).should exist
      @ie.file_field(:name, 'new_user_portrait').should exist
      @ie.file_field(:name, /new_user_portrait/).should exist
      @ie.file_field(:class, 'portrait').should exist
      @ie.file_field(:class, /portrait/).should exist
      @ie.file_field(:index, 1).should exist
      @ie.file_field(:xpath, "//input[@id='new_user_portrait']").should exist
    end
    
    it "should return false if the file field doesn't exist" do
      @ie.file_field(:id, 'no_such_id').should_not exist
      @ie.file_field(:id, /no_such_id/).should_not exist
      @ie.file_field(:name, 'no_such_name').should_not exist
      @ie.file_field(:name, /no_such_name/).should_not exist
      @ie.file_field(:class, 'no_such_class').should_not exist
      @ie.file_field(:class, /no_such_class/).should_not exist
      @ie.file_field(:index, 1337).should_not exist
      @ie.file_field(:xpath, "//input[@id='no_such_id']").should_not exist
    end
    
    it "should raise ArgumentError when what argument is invalid" do
      lambda { @ie.file_field(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end

    it "should raise MissingWayOfFindingObjectException when how argument is invalid" do
      lambda { @ie.file_field(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  
  # Attribute methods

  describe "#class_name" do
    it "should return the class attribute if the text field exists" do
      @ie.file_field(:index, 1).class_name.should == "portrait"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.file_field(:index, 1337).class_name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#id" do
    it "should return the id attribute if the text field exists" do
      @ie.file_field(:index, 1).id.should == "new_user_portrait"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.file_field(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#name" do
    it "should return the name attribute if the text field exists" do
      @ie.file_field(:index, 1).name.should == "new_user_portrait"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.file_field(:index, 1337).name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#title" do
    it "should return the title attribute if the text field exists" do
      @ie.file_field(:id, "new_user_portrait").title.should == "Smile!"
    end
  end
  
  describe "#type" do
    it "should return the type attribute if the text field exists" do
      @ie.file_field(:index, 1).type.should == "file"
    end
    it "should raise UnknownObjectException if the text field doesn't exist" do
      lambda { @ie.file_field(:index, 1337).type }.should raise_error(UnknownObjectException)
    end
  end
  
  
  # Manipulation methods
    
  describe "#set" do
    it "should be able to set a file path in the field and click the upload button" do
      @ie.file_field(:name, "new_user_portrait").set(__FILE__)
      @ie.file_field(:name, "new_user_portrait").value.should == __FILE__
      # @ie.button(:name, "new_user_submit").click
      pending
    end
  end

  after :all do
    @ie.close
  end

end

