module Celerity
  Jars = Dir[File.dirname(__FILE__) + '/htmlunit/*.jar']
end

Celerity::Jars.each { |jar| require(jar) }

HtmlUnit       = com.gargoylesoftware.htmlunit
HtmlUnit::Html = com.gargoylesoftware.htmlunit.html

module Java::OrgW3cDom::NamedNodeMap
  include Enumerable
  
  def each
    0.upto(getLength - 1) do |idx|
      yield item(idx)
    end
  end
end

# this will be added in JRuby 1.1.6
module Java::JavaLang::Iterable
  include Enumerable
  
  def each
    it = iterator
    yield it.next while it.hasNext
  end
  
end


