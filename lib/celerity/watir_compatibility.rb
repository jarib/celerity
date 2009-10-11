module Celerity
  class Browser
    class << self

      # Added for Watir compatibility - not in use by Celerity
      attr_accessor :speed, :attach_timeout, :visible
      # Added for Watir compatibility - not in use by Celerity
      alias_method :start_window, :start
      # Added for Watir compatibility - not in use by Celerity
      def each; end
    end

    # Added for Watir compatibility - not in use by Celerity
    attr_accessor :visible

    # Added for Watir compatibility - not in use by Celerity
    def bring_to_front; true; end
    # Added for Watir compatibility - not in use by Celerity
    def speed=(s); s end
  end


  module ClickableElement
    alias_method :click_no_wait,    :click
  end

  module Container
    alias_method :checkbox,         :check_box
    alias_method :checkBox,         :check_box
    alias_method :body,             :tbody
    alias_method :bodies,           :tbodies
  end

  class Element
    alias_method :exists,           :exists?
    alias_method :innerText,        :text
    alias_method :inner_text,       :text
  end

  class Image
    alias_method :hasLoaded?,       :loaded?
    alias_method :fileSize,         :file_size
    alias_method :fileCreatedDate,  :file_created_date
  end

   class Link
     alias_method :click_no_wait,   :click
   end

  class RadioCheckCommon
    alias_method :isSet?,           :set?
    alias_method :getState,         :set?
  end

  class SelectList
    alias_method :getSelectedItems, :selected_options
    alias_method :getAllContents,   :options
    alias_method :clearSelection,   :clear
    alias_method :includes?,        :include?
  end

  class TextField
    alias_method :dragContentsTo,   :drag_contents_to
    alias_method :getContents,      :value

    def requires_typing; end
  end
end

Celerity::IE = Celerity::Browser