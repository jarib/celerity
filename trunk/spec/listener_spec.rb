require File.dirname(__FILE__) + "/spec_helper"

describe "Listener" do
  before(:each) do
    @web_client = mock("WebClient", :null_object => true)
    @listener = Celerity::Listener.new(@web_client)
  end

  it "should implement the StatusHandler interface" do
    @listener.should be_a_kind_of(com.gargoylesoftware.htmlunit.StatusHandler)

    @listener.should respond_to(:statusMessageChanged)
    lambda { @listener.statusMessageChanged('page', 'message') }.should_not raise_error
  end

  it "should implement the ConfirmHandler interface" do
    @listener.should be_a_kind_of(com.gargoylesoftware.htmlunit.ConfirmHandler)

    @listener.should respond_to(:handleConfirm)
    lambda { @listener.handleConfirm('page', 'message') }.should_not raise_error
  end

  it "should implement the AttachmentHandler interface" do
    @listener.should be_a_kind_of(com.gargoylesoftware.htmlunit.attachment.AttachmentHandler)

    @listener.should respond_to(:handleAttachment)
    lambda { @listener.handleAttachment('page') }.should_not raise_error
  end

  it "should implement the AlertHandler interface" do
    @listener.should be_a_kind_of(com.gargoylesoftware.htmlunit.AlertHandler)

    @listener.should respond_to(:handleAlert)
    lambda { @listener.handleAlert('page', 'message') }.should_not raise_error
  end

  it "should implement the HTMLParserListener interface" do
    @listener.should be_a_kind_of(com.gargoylesoftware.htmlunit.html.HTMLParserListener)

    @listener.should respond_to(:error)
    @listener.should respond_to(:warning)

    lambda { @listener.error('message', 'url', 1, 2, "key") }.should_not raise_error
    lambda { @listener.warning('message', 'url', 1, 2, "key") }.should_not raise_error
  end

  it "should implement the WebWindowListener interface" do
    @listener.should be_a_kind_of(com.gargoylesoftware.htmlunit.WebWindowListener)

    @listener.should respond_to(:webWindowClosed)
    @listener.should respond_to(:webWindowContentChanged)
    @listener.should respond_to(:webWindowOpened)

    lambda { @listener.webWindowClosed('event') }.should_not raise_error
    lambda { @listener.webWindowContentChanged('event') }.should_not raise_error
    lambda { @listener.webWindowOpened('event') }.should_not raise_error
  end

  it "should implement the IncorrectnessListener interface" do
    @listener.should be_a_kind_of(com.gargoylesoftware.htmlunit.IncorrectnessListener)

    @listener.should respond_to(:notify)
    lambda { @listener.notify('message', 'origin') }.should_not raise_error
  end

  it "should implement the PromptHandler interface" do
    @listener.should be_a_kind_of(com.gargoylesoftware.htmlunit.PromptHandler)

    @listener.should respond_to(:handlePrompt)
    lambda { @listener.handlePrompt('page', 'message') }.should_not raise_error
  end


  describe "#add_listener" do
    it "should add itself as a listener for the :status type" do
      @web_client.should_receive('setStatusHandler').with(@listener)
      @listener.add_listener(:status) {}
    end

    it "should add itself as a listener for the :alert type" do
      @web_client.should_receive('setAlertHandler').with(@listener)
      @listener.add_listener(:alert) {}
    end

    it "should add itself as a listener for the :confirm type" do
      @web_client.should_receive('setConfirmHandler').with(@listener)
      @listener.add_listener(:confirm) {}
    end

    it "should add itself as a listener for the :prompt type" do
      @web_client.should_receive('setPromptHandler').with(@listener)
      @listener.add_listener(:prompt) {}
    end

    it "should add itself as a listener for the :web_window_event type" do
      @web_client.should_receive('addWebWindowListener').with(@listener)
      @listener.add_listener(:web_window_event) {}
    end

    it "should add itself as a listener for the :html_parser type" do
      @web_client.should_receive('setHTMLParserListener').with(@listener)
      @listener.add_listener(:html_parser) {}
    end

    it "should add itself as a listener for the :incorrectness type" do
      @web_client.should_receive('setIncorrectnessListener').with(@listener)
      @listener.add_listener(:incorrectness) {}
    end

    it "should add itself as a listener for the :attachment type" do
      @web_client.should_receive('setAttachmentHandler').with(@listener)
      @listener.add_listener(:attachment) {}
    end
  end

  describe "#remove_listener" do
    it "should remove the listener at the given index" do
      updates = []
      first, second = lambda { updates << :first }, lambda { updates << :second }

      @listener.add_listener(:prompt, &first)
      @listener.add_listener(:prompt, &second)

      @listener.remove_listener(:prompt, 0)
      @listener.handlePrompt('foo', 'bar')
      updates.should == [:second]
    end
  end

end