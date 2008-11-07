require File.dirname(__FILE__) + "/spec_helper"

describe "Listener" do
  before(:each) do
    @web_client = mock("WebClient")
    @listener = Celerity::Listener.new(@web_client)
  end

  describe "add_listener" do
    it "should add the itself as a listener for the given type" do
      @web_client.should_receive('setStatusHandler').with(@listener)
      @listener.add_listener(:status) {}
    end
  end
  
end