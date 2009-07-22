module Celerity
  class IgnoringWebConnection < HtmlUnit::Util::FalsifyingWebConnection

    def initialize(web_client, pattern)
      super(web_client)
      @pattern = pattern
    end

    def getResponse(request_settings)
      return super unless request_settings.getUrl.toString =~ @pattern
      createWebResponse(request_settings, "", "text/html")
    end

  end
end