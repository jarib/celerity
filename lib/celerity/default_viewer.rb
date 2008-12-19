module Celerity
  class DefaultViewer
    IMAGE = "#{Celerity::DIR}/resources/no_viewer.png"
    
    def self.save(path = nil)
      return unless path
      FileUtils.copy(IMAGE, path)
    end
  end
end