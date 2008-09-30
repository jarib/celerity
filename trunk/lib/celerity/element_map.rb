module Celerity
  module ElementMap
    # Some HtmlUnit classes are missing equivalents in Celerity. Shouldn't be too hard to fix.
    # This is mostly used to implement Element#parent easily.
    HtmlUnit2CelerityElement = {
      HtmlUnit::Html::HtmlAnchor           => Celerity::Link,
      HtmlUnit::Html::HtmlArea             => Celerity::Area,
      HtmlUnit::Html::HtmlButton           => Celerity::Button,
      HtmlUnit::Html::HtmlButtonInput      => Celerity::Button,
      HtmlUnit::Html::HtmlCaption          => Celerity::Button, # ?
      HtmlUnit::Html::HtmlCheckBoxInput    => Celerity::CheckBox,
      HtmlUnit::Html::HtmlDivision         => Celerity::Div,
      HtmlUnit::Html::HtmlFileInput        => Celerity::FileField,
      HtmlUnit::Html::HtmlForm             => Celerity::Form,
      HtmlUnit::Html::HtmlFrame            => Celerity::Frame,
      HtmlUnit::Html::HtmlHeading1         => Celerity::H1,
      HtmlUnit::Html::HtmlHeading2         => Celerity::H2,
      HtmlUnit::Html::HtmlHeading3         => Celerity::H3,
      HtmlUnit::Html::HtmlHeading4         => Celerity::H4,
      HtmlUnit::Html::HtmlHeading5         => Celerity::H5,
      HtmlUnit::Html::HtmlHeading6         => Celerity::H6,
      HtmlUnit::Html::HtmlHiddenInput      => Celerity::Hidden,
      HtmlUnit::Html::HtmlImage            => Celerity::Image,
      HtmlUnit::Html::HtmlLabel            => Celerity::Label,
      HtmlUnit::Html::HtmlLink             => Celerity::Link,
      HtmlUnit::Html::HtmlListItem         => Celerity::Li,
      HtmlUnit::Html::HtmlMap              => Celerity::Map,
      HtmlUnit::Html::HtmlOption           => Celerity::Option,
      HtmlUnit::Html::HtmlOrderedList      => Celerity::Ol,
      HtmlUnit::Html::HtmlParagraph        => Celerity::P,
      HtmlUnit::Html::HtmlPasswordInput    => Celerity::TextField,
      HtmlUnit::Html::HtmlPreformattedText => Celerity::Pre,
      HtmlUnit::Html::HtmlRadioButtonInput => Celerity::Radio,
      HtmlUnit::Html::HtmlSelect           => Celerity::SelectList,
      HtmlUnit::Html::HtmlSpan             => Celerity::Span,
      HtmlUnit::Html::HtmlTable            => Celerity::Table,
      HtmlUnit::Html::HtmlTableBody        => Celerity::TableBody,
      HtmlUnit::Html::HtmlTableCell        => Celerity::TableCell,
      HtmlUnit::Html::HtmlTableFooter      => Celerity::TableFooter,
      HtmlUnit::Html::HtmlTableHeader      => Celerity::TableHeader,
      HtmlUnit::Html::HtmlTableRow         => Celerity::TableRow,
      HtmlUnit::Html::HtmlTextArea         => Celerity::Area,
      HtmlUnit::Html::HtmlTextInput        => Celerity::TextField,
      HtmlUnit::Html::HtmlUnorderedList    => Celerity::Ul
    }
  end
end

class Celerity::Element
  include Celerity::ElementMap
end