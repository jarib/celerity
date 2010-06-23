module Celerity
  class PageCreator < HtmlUnit::DefaultPageCreator
    
    def createPage(response, window)
      if response.isBigContent && "html" == determinePageType(response.getContentType.downcase) 
        createHtmlPage(response, window)
      else
        super
      end
    end
    
  end # PageCreator
end # Celerity