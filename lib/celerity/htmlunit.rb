module Celerity
  Jars = Dir[File.dirname(__FILE__) + '/htmlunit/*.jar']
  Jars.each { |jar| require(jar) }

  module JsxHelper
    def method_missing(meth, *args, &blk)
      m = ["jsxGet_#{meth}", "jsx_get_#{meth}"].find { |m| respond_to?(m) }
      m ? __send__(m) : super
    end
  end
end

module HtmlUnit
  include_package 'com.gargoylesoftware.htmlunit'

  module Html
    include_package 'com.gargoylesoftware.htmlunit.html'
  end

  module Util
    include_package 'com.gargoylesoftware.htmlunit.util'
  end

end

module Java::OrgW3cDom::NamedNodeMap
  include Enumerable

  def each
    0.upto(getLength - 1) do |idx|
      yield item(idx)
    end
  end
end

module Java::JavaLang::Iterable
  include Enumerable

  def each
    it = iterator
    yield it.next while it.hasNext
  end

end unless Java::JavaLang::Iterable < Enumerable # depends on JRuby version

class Java::ComGargoylesoftwareHtmlunitHtml::HtmlPage
  def inspect
    '#<HtmlPage:0x%s(%s)>' % [self.hash.to_s(16), getWebResponse.getWebRequest.getUrl.toString]
  end
end

class Java::ComGargoylesoftwareHtmlunitHtml::HtmlElement
  def inspect
    '#<%s:0x%s>' % [self.class.name.split("::").last, self.hash.to_s(16)]
  end
end

class Java::ComGargoylesoftwareHtmlunitJavascriptHostHtml::HTMLElement
  include Celerity::JsxHelper
end

class Java::ComGargoylesoftwareHtmlunitJavascriptHostCss::CSSStyleDeclaration
  include Celerity::JsxHelper
end