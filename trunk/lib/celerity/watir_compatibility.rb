module Celerity
  class IE
    # these are just for Watir compatability - should we keep them?
    class << self
      attr_accessor :speed, :attach_timeout, :visible
      alias_method :start_window, :start
      def reset_attach_timeout; @attach_timeout = 2.0; end
      def each; end
      def quit; end
      def set_fast_speed; @speed = :fast; end
      def set_slow_speed; @speed = :slow; end  
    end

    attr_accessor :visible
   
    def bring_to_front; true; end
    def speed=(s); end
    def wait; end
  end
  
  module ClickableElement
    alias_method :click_no_wait, :click
  end
    
  class Image
    alias_method :hasLoaded?, :loaded?
    alias_method :has_loaded?, :loaded?
    alias_method :fileSize, :file_size
    alias_method :fileCreatedDate, :file_created_date
  end
  
   class Link
     alias_method :click_no_wait, :click
   end
  
  class RadioCheckCommon
    alias_method :is_set?, :set?
    alias_method :get_state, :set?
    alias_method :isSet?, :set?
    alias_method :getState, :set?
  end
  
  class SelectList
    alias_method :getSelectedItems, :get_selected_items
    alias_method :getAllContents, :get_all_contents
    alias_method :clearSelection, :clear_selection
    alias_method :select_value, :select
  end
  
  class TextField
    alias_method :dragContentsTo, :drag_contents_to
    alias_method :getContents, :get_contents
  end
end