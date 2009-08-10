module Celerity
  class DefaultViewer
    IMAGE = "#{Celerity::DIR}/resources/no_viewer.png"

    class << self
      def save(path = nil)
        return unless path
        FileUtils.copy(IMAGE, path)
      end

      def close; end
    end
  end
end