# encoding: utf-8

require File.expand_path("../watirspec/spec_helper", __FILE__)

describe "Browser" do
  describe "#new" do
    it "raises TypeError if argument is not a Hash" do
      lambda { Browser.new(:foo) }.should raise_error(TypeError)
    end

    it "raises ArgumentError if given bad arguments for :render key" do
      lambda { Browser.new(:render => :foo) }.should raise_error(ArgumentError)
    end

    it "raises ArgumentError if given bad arguments for :browser key" do
      lambda { Browser.new(:browser => 'foo') }.should raise_error(ArgumentError)
    end

    it "raises ArgumentError if given an unknown option" do
      lambda { Browser.new(:foo => 1) }.should raise_error(ArgumentError)
    end

    it "should hold the init options" do
      browser.options.should == WatirSpec.implementation.browser_args.first
    end

    it "should use the specified proxy" do
      # TODO: find a better way to test this with rack
      require 'webrick/httpproxy'

      received = false
      blk      = lambda { received = true }
      port     = WatirSpec::Server.find_free_port_above(2001)

      s = WEBrick::HTTPProxyServer.new(:Port => port,
                                       :ProxyContentHandler => blk)
      Thread.new { s.start }

      opts = WatirSpec.implementation.browser_args.first.merge(:proxy => "localhost:#{port}")

      begin
        b = Browser.new(opts)
        b.goto(WatirSpec.host)
      ensure
        s.shutdown
        b.close if b
      end

      received.should be_true
    end

    it "should use the specified user agent" do
      opts = WatirSpec.implementation.browser_args.first.merge(:user_agent => "Celerity")

      b = Browser.new(opts)

      begin
        b.goto(WatirSpec.host + "/header_echo")
        b.text.should include('"HTTP_USER_AGENT"=>"Celerity"')
      ensure
        b.close
      end
    end

    it "does not try to find a viewer if created with :viewer => false" do
      ViewerConnection.should_not_receive(:create)

      Browser.new(:viewer => false).close
    end

    it "tries to find a viewer if created with :viewer => nil" do
      ViewerConnection.should_receive(:create).with("127.0.0.1", 6429)

      Browser.new(:viewer => nil).close
    end

    it "tries to find a viewer on the specified host/port with :viewer => String" do
      ViewerConnection.should_receive(:create).with("localhost", 1234)

      Browser.new(:viewer => "localhost:1234").close
    end

    it "should use the specified cache limit" do
      opts = WatirSpec.implementation.browser_args.first.merge(:cache_limit => 100)
      b = Browser.new(opts)

      begin
        b.cache_limit.should == 100
      ensure
        b.close
      end
    end

    it "should use the Firefox 3 browser version when specified" do
      Browser.new(:browser => :firefox).webclient.browser_version.nickname.should == "FF3"
      Browser.new(:browser => :firefox3).webclient.browser_version.nickname.should == "FF3"
    end

    it "should use the Firefox 3.6 browser version when specified" do
      Browser.new(:browser => :firefox_3_6).webclient.browser_version.nickname.should == "FF3.6"
      Browser.new(:browser => :ff36).webclient.browser_version.nickname.should == "FF3.6"
    end

    it "should use the Internet Explorer 7 browser version when specified" do
      Browser.new(:browser => :internet_explorer).webclient.browser_version.nickname.should == "IE7"
      Browser.new(:browser => :internet_explorer7).webclient.browser_version.nickname.should == "IE7"
      Browser.new(:browser => :internet_explorer_7).webclient.browser_version.nickname.should == "IE7"
      Browser.new(:browser => :ie).webclient.browser_version.nickname.should == "IE7"
    end

    it "should use the Internet Explorer 8 browser version when specified" do
      Browser.new(:browser => :internet_explorer_8).webclient.browser_version.nickname.should == "IE8"
      Browser.new(:browser => :ie8).webclient.browser_version.nickname.should == "IE8"
    end

    it "should turn off CSS" do
      b = Browser.new(:css => false)
      b.css.should be_false
    end

  end

  describe "#html" do
    %w(shift_jis iso-2022-jp euc-jp).each do |charset|
      it "returns decoded #{charset.upcase} when :charset specified" do
        opts = WatirSpec.implementation.browser_args.first.merge(:charset => charset.upcase)
        browser = Browser.new(opts)

        begin
          browser.goto(WatirSpec.files + "/#{charset}_text.html")
          # Browser#text is automagically transcoded into the right charset, but Browser#html isn't.
          browser.html.should =~ /本日は晴天なり。/
        ensure
          browser.close
        end
      end
    end

    it "does not fail for huge pages" do
      browser.goto WatirSpec.host + "/big"
      browser.html.should include("hello</body>")
    end
  end

  describe "#text" do
    it "does not fail for huge pages" do
      browser.goto WatirSpec.host + "/big"
      browser.text.should include("hello")
    end
  end

  describe "#response_headers" do
    it "returns the response headers (as a hash)" do
      browser.goto(WatirSpec.host + "/non_control_elements.html")
      browser.response_headers.should be_kind_of(Hash)
      browser.response_headers['Date'].should be_kind_of(String)
      browser.response_headers['Content-Type'].should be_kind_of(String)
    end
  end

  describe "#content_type" do
    it "returns the content type" do
      browser.goto(WatirSpec.host + "/non_control_elements.html")
      browser.content_type.should =~ /\w+\/\w+/
    end
  end

  describe "#io" do
    it "returns the io object of the content" do
      browser.goto(WatirSpec.files + "/non_control_elements.html")
      browser.io.should be_kind_of(IO)
      browser.io.read.should == File.read("#{WatirSpec.html}/non_control_elements.html")
    end
  end

  describe "#goto" do
    it "raises UnexpectedPageException if the content type is not understood" do
      lambda { browser.goto(WatirSpec.host + "/octet_stream") }.should raise_error(UnexpectedPageException)
    end

    it "takes a 2nd argument of headers" do
      browser.goto(WatirSpec.host + "/header_echo", {'Accept-Language'=>'fr','Accept'=>'application/json'})
      browser.text.should include('"HTTP_ACCEPT"=>"application/json"')
      browser.text.should include('"HTTP_ACCEPT_LANGUAGE"=>"fr"')
    end
  end

  describe "#cookies" do
    it "returns set cookies as a Ruby hash" do
      browser = WatirSpec.new_browser
      begin
        browser.cookies.should == {}

        browser.goto(WatirSpec.host + "/set_cookie")

        cookies = browser.cookies
        cookies.size.should == 1
        cookies[WatirSpec::Server.bind]['monster'].should == "/"
      ensure
        browser.close
      end
    end
  end

  describe "#clear_cookies" do
    it "clears all cookies" do
      b = WatirSpec.new_browser

      begin
        b.cookies.should be_empty

        b.goto(WatirSpec.host + "/set_cookie")
        b.cookies.size.should == 1
        b.clear_cookies
        b.cookies.should be_empty
      ensure
        b.close
      end
    end
  end

  describe "add_cookie" do
    it "adds a cookie with the given domain, name and value" do
      begin
        browser.add_cookie("example.com", "foo", "bar")
        cookies = browser.cookies
        cookies.should be_instance_of(Hash)
        cookies.should have_key('example.com')
        cookies['example.com']['foo'].should == 'bar'
      ensure
        browser.clear_cookies
      end
    end

    it "adds a cookie with the specified options" do
      begin
        browser.add_cookie("example.com", "foo", "bar", :path => "/foobar", :expires => Time.now + 100000)
        cookies = browser.cookies
        cookies.should be_instance_of(Hash)
        cookies['example.com']['foo'].should == 'bar'
      ensure
        browser.clear_cookies
      end
    end
  end

  describe "remove_cookie" do
    it "removes the cookie for the given domain and name" do
      b = WatirSpec.new_browser
      begin
        b.goto(WatirSpec.host + "/set_cookie")

        b.remove_cookie(WatirSpec::Server.bind, "monster")
        b.cookies.should be_empty
      ensure
        b.close
      end
    end

    it "raises an error if no such cookie exists" do
      lambda { browser.remove_cookie("bogus.com", "bar") }.should raise_error(CookieNotFoundError)
    end
  end

  describe "#wait" do
    it "should wait for javascript timers to finish" do
      alerts = 0
      browser.add_listener(:alert) { alerts += 1 }
      browser.goto(WatirSpec.files + "/timeout.html")
      browser.div(:id, 'alert').click
      browser.wait.should be_true
      alerts.should == 1
    end

    it "should pass the correct args to webclient" do
      browser.webclient.should_receive(:waitForBackgroundJavaScript).with(10000)
      browser.wait

      browser.webclient.should_receive(:waitForBackgroundJavaScript).with(3000)
      browser.wait(3)
    end

  end

  describe "#wait_while" do
    it "waits until the specified condition becomes false" do
      browser.goto(WatirSpec.files + "/timeout.html")
      browser.div(:id, "change").click
      browser.wait_while { browser.contains_text("Trigger change") }
      browser.wait_until {
        browser.div(:id, "change").text == "all done"
      }
    end

    it "returns the value returned from the block" do
      browser.wait_while { false }.should == false
    end
  end

  describe "#wait_until" do
    it "waits until the condition becomes true" do
      browser.goto(WatirSpec.files + "/timeout.html")
      browser.div(:id, "change").click
      browser.wait_until { browser.contains_text("all done") }
    end

    it "returns the value returned from the block" do
      browser.wait_until { true }.should == true
    end
  end

  describe "#element_by_xpath" do
    it "returns usable elements even though they're not supported" do
      browser.goto(WatirSpec.files + "/forms_with_input_elements.html")

      el = browser.element_by_xpath("//link")
      el.should be_instance_of(Celerity::Element)
      el.should be_kind_of(Celerity::ClickableElement)
      el.rel.should == "stylesheet"
    end

    it "includes the xpath in an exception message" do
      browser.goto(WatirSpec.files + "/forms_with_input_elements.html")

      the_xpath = "//div[contains(@class, 'this does not exist')]"
      el = browser.element_by_xpath(the_xpath)

      lambda { el.visible? }.should raise_error(
        Celerity::Exception::UnknownObjectException, Regexp.new(Regexp.escape(the_xpath)))
    end
  end

  describe "#focused_element" do
    it "returns the element that currently has the focus" do
      b = WatirSpec.new_browser
      b.goto(WatirSpec.files + "/forms_with_input_elements.html")
      b.focused_element.id.should == "new_user_first_name"

      b.close
    end
  end

  describe "#status_code" do
    it "returns the status code of the last request" do
      browser.goto(WatirSpec.files + "/forms_with_input_elements.html")
      browser.status_code.should == 200

      browser.goto(WatirSpec.host + "/doesnt_exist")
      browser.status_code.should == 404
    end
  end

  describe "#status_code_exceptions" do
    it "raises status code exceptions if set to true" do
      browser.status_code_exceptions = true

      begin
        lambda {
          browser.goto(WatirSpec.host + "/doesnt_exist")
        }.should raise_error(NavigationException)
      ensure
        browser.status_code_exceptions = false
      end
    end
  end

  describe "#javascript_exceptions" do
    it "raises javascript exceptions if set to true" do
      browser.goto(WatirSpec.files + "/forms_with_input_elements.html")
      browser.javascript_exceptions = true
      begin
        lambda { browser.execute_script("no_such_function()") }.should raise_error
      ensure
        browser.javascript_exceptions = false
      end
    end
  end

  describe "#add_listener" do
    it "should click OK for confirm() calls" do
      browser.goto(WatirSpec.files + "/forms_with_input_elements.html")
      browser.add_listener(:confirm) {  }
      browser.execute_script("confirm()").should == true
    end
  end

  describe "#remove_listener" do
    it "should remove the given listener Proc" do
      browser.goto(WatirSpec.files + "/forms_with_input_elements.html")

      called   = false
      listener = lambda { called = true }

      browser.add_listener(:alert, &listener)
      browser.execute_script("alert('foo')")
      called.should be_true

      called = false
      browser.remove_listener(:alert, listener)
      browser.execute_script("alert('foo')")
      called.should be_false
    end
  end

  describe "#add_checker" do

    # watir only supports a lambda instance as argument, celerity supports both
    it "runs the given block on each page load" do
      output = ''

      browser.add_checker { |browser| output << browser.text }
      browser.goto(WatirSpec.files + "/non_control_elements.html")

      output.should include('Dubito, ergo cogito, ergo sum')
    end
  end


  describe "#confirm" do
    it "clicks 'OK' for a confirm() call" do
      browser.goto(WatirSpec.files + "/forms_with_input_elements.html")

      browser.confirm(true) do
        browser.execute_script('confirm()').should be_true
      end
    end

    it "clicks 'cancel' for a confirm() call" do
      browser.goto(WatirSpec.files + "/forms_with_input_elements.html")

      browser.confirm(false) do
        browser.execute_script('confirm()').should be_false
      end
    end
  end



end
