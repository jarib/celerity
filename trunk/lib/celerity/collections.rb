module Celerity

 class Buttons < ElementCollections
    def element_class; Button; end
  end

  class FileFields < ElementCollections
    def element_class; FileField; end
  end

  class CheckBoxes < ElementCollections
    def element_class; CheckBox; end
  end

  class Radios < ElementCollections
    def element_class; Radio; end
  end

  class SelectLists < ElementCollections
    def element_class; SelectList; end
  end

  class Links < ElementCollections
    def element_class; Link; end
  end

  class Lis < ElementCollections
    def element_class; Li; end
  end

  class Maps < ElementCollections
    def element_class; Map; end
  end

  class Areas < ElementCollections
    def element_class; Area; end
  end

  class Images < ElementCollections
    def element_class; Image; end
  end

  class TextFields < ElementCollections
    def element_class; TextField; end
  end

  class Hiddens < ElementCollections
    def element_class; Hidden; end
  end

  class Tables < ElementCollections
    def element_class; Table; end
  end
  
  class TableBodies < ElementCollections
    def element_class; TableBody; end
  end

  class TableRows < ElementCollections
    def element_class; TableRow; end
  end

  class TableCells < ElementCollections
    def element_class; TableCell; end
  end

  class Labels < ElementCollections
    def element_class; Label; end
  end

  class Pres < ElementCollections
    def element_class; Pre; end
  end

  class Ps < ElementCollections
    def element_class; P; end
  end

  class Spans < ElementCollections
    def element_class; Span; end
  end

  class Divs < ElementCollections
    def element_class; Div; end
  end
  
  class Forms < ElementCollections
    def element_class; Form; end
  end

end