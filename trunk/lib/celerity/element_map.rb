module Celerity
  module ElementMap
    # Some HtmlUnit classes are missing equivalents in Celerity. Shouldn't be too hard to implement most of them.
    # This is mostly used to implement Element#parent easily.
    HtmlUnit2CelerityElement = {
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlAnchor           => Celerity::Link,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlArea             => Celerity::Area,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlButton           => Celerity::Button,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlButtonInput      => Celerity::Button,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlCaption          => Celerity::Button, # ?
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlCheckBoxInput    => Celerity::CheckBox,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlDivision         => Celerity::Div,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlFileInput        => Celerity::FileField,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlForm             => Celerity::Form,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlFrame            => Celerity::Frame,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlHeading1         => Celerity::H1,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlHeading2         => Celerity::H2,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlHeading3         => Celerity::H3,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlHeading4         => Celerity::H4,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlHeading5         => Celerity::H5,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlHeading6         => Celerity::H6,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlHiddenInput      => Celerity::Hidden,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlImage            => Celerity::Image,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlLabel            => Celerity::Label,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlLink             => Celerity::Link,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlListItem         => Celerity::Li,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlMap              => Celerity::Map,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlOption           => Celerity::Option,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlOrderedList      => Celerity::Ol,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlParagraph        => Celerity::P,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlPasswordInput    => Celerity::TextField,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlPreformattedText => Celerity::Pre,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlRadioButtonInput => Celerity::Radio,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlSelect           => Celerity::SelectList,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlSpan             => Celerity::Span,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlTable            => Celerity::Table,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlTableBody        => Celerity::TableBody,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlTableCell        => Celerity::TableCell,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlTableFooter      => Celerity::TableFooter,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlTableHeader      => Celerity::TableHeader,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlTableRow         => Celerity::TableRow,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlTextArea         => Celerity::Area,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlTextInput        => Celerity::TextField,
      Java::ComGargoylesoftwareHtmlunitHtml::HtmlUnorderedList    => Celerity::Ul
    }
  end
end

class Celerity::Element 
  include Celerity::ElementMap
end