describe Celerity do
  it "should raise error if run on MRI" do
    `ruby #{File.dirname(__FILE__) + "/../lib/celerity"}`
    $?.should_not be_success
  end
end