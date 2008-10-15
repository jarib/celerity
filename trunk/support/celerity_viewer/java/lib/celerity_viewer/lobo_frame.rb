class LoboFrame < Swing::JFrame
  def initialize
    @frame_panel = org.lobobrowser.gui.FramePanel.new
    super
    self.getContentPane.add(@frame_panel)
  end

  def goto(url)
    @frame_panel.navigate(url)
  end
end

