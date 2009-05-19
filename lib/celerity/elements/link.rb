module Celerity
  class Link < Element
    include ClickableElement

    TAGS = [ Identifier.new('a') ]
    ATTRIBUTES = BASE_ATTRIBUTES | [:charset, :type, :name, :href, :hreflang,
                                    :target, :rel, :rev, :accesskey, :shape,
                                    :coords, :tabindex, :onfocus, :onblur]
    DEFAULT_HOW = :href

    #
    # Returns the absolute URL for this link (Celerity-specific)
    #
    # (Watir/IE does this for href(), but we don't want that.)
    #

    def absolute_url
      assert_exists
      href = @object.getAttribute('href')

      unless href.empty? || URI.parse(href).absolute?
        href = URI.join(browser.url, href).to_s
      end

      href
    end


  end # Link
end # Celerity