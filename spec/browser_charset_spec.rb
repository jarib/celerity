require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Browser" do

  %w(shift_jis iso-2022-jp euc-jp).each do |charset|
    it ".html returns decoded #{charset.upcase} when :charset specified" do
      browser = Browser.new(:charset => charset.upcase)
      browser.goto(HTML_DIR + "/#{charset}_text.html")
      browser.html.should =~ /本日は晴天なり。/ # Browser#text is automagically transcoded into the right charset, but Browser#html isn't.
    end
  end

end