module Celerity
  module Util
    module_function

    HtmlUnit2CelerityElement = {
      HtmlUnit::Html::HtmlAnchor                => Celerity::Link,
      HtmlUnit::Html::HtmlArea                  => Celerity::Area,
      HtmlUnit::Html::HtmlButton                => Celerity::Button,
      HtmlUnit::Html::HtmlSubmitInput           => Celerity::Button,
      HtmlUnit::Html::HtmlResetInput            => Celerity::Button,
      HtmlUnit::Html::HtmlImageInput            => Celerity::Button,
      HtmlUnit::Html::HtmlButtonInput           => Celerity::Button,
      HtmlUnit::Html::HtmlCaption               => Celerity::Button, # ?
      HtmlUnit::Html::HtmlCheckBoxInput         => Celerity::CheckBox,
      HtmlUnit::Html::HtmlDefinitionDescription => Celerity::Dd,
      HtmlUnit::Html::HtmlDefinitionList        => Celerity::Dl,
      HtmlUnit::Html::HtmlDefinitionTerm        => Celerity::Dt,
      HtmlUnit::Html::HtmlDivision              => Celerity::Div,
      HtmlUnit::Html::HtmlFileInput             => Celerity::FileField,
      HtmlUnit::Html::HtmlForm                  => Celerity::Form,
      HtmlUnit::Html::HtmlFrame                 => Celerity::Frame,
      HtmlUnit::Html::HtmlHeading1              => Celerity::H1,
      HtmlUnit::Html::HtmlHeading2              => Celerity::H2,
      HtmlUnit::Html::HtmlHeading3              => Celerity::H3,
      HtmlUnit::Html::HtmlHeading4              => Celerity::H4,
      HtmlUnit::Html::HtmlHeading5              => Celerity::H5,
      HtmlUnit::Html::HtmlHeading6              => Celerity::H6,
      HtmlUnit::Html::HtmlHiddenInput           => Celerity::Hidden,
      HtmlUnit::Html::HtmlImage                 => Celerity::Image,
      HtmlUnit::Html::HtmlLabel                 => Celerity::Label,
      HtmlUnit::Html::HtmlListItem              => Celerity::Li,
      HtmlUnit::Html::HtmlMap                   => Celerity::Map,
      HtmlUnit::Html::HtmlOption                => Celerity::Option,
      HtmlUnit::Html::HtmlOrderedList           => Celerity::Ol,
      HtmlUnit::Html::HtmlParagraph             => Celerity::P,
      HtmlUnit::Html::HtmlPasswordInput         => Celerity::TextField,
      HtmlUnit::Html::HtmlPreformattedText      => Celerity::Pre,
      HtmlUnit::Html::HtmlRadioButtonInput      => Celerity::Radio,
      HtmlUnit::Html::HtmlSelect                => Celerity::SelectList,
      HtmlUnit::Html::HtmlSpan                  => Celerity::Span,
      HtmlUnit::Html::HtmlTable                 => Celerity::Table,
      HtmlUnit::Html::HtmlTableBody             => Celerity::TableBody,
      HtmlUnit::Html::HtmlTableCell             => Celerity::TableCell,
      HtmlUnit::Html::HtmlTableFooter           => Celerity::TableFooter,
      HtmlUnit::Html::HtmlTableHeader           => Celerity::TableHeader,
      HtmlUnit::Html::HtmlTableRow              => Celerity::TableRow,
      HtmlUnit::Html::HtmlTextArea              => Celerity::TextField,
      HtmlUnit::Html::HtmlTextInput             => Celerity::TextField,
      HtmlUnit::Html::HtmlUnorderedList         => Celerity::Ul
    }

    def htmlunit2celerity(klass)
      HtmlUnit2CelerityElement[klass]
    end

    #
    # HtmlUnit will recognize most common file types, but custom ones can be added here.
    # Used for FileField uploads.
    #

    ContentTypes = {
      ".bmp" => "image/x-ms-bmp",
      ".doc" => "application/msword",
      ".odg" => "application/vnd.oasis.opendocument.graphics",
      ".odp" => "application/vnd.oasis.opendocument.presentation",
      ".ods" => "application/vnd.oasis.opendocument.spreadsheet",
      ".odt" => "application/vnd.oasis.opendocument.text",
      ".ppt" => "application/vnd.ms-powerpoint",
      ".xls" => "application/vnd.ms-excel",
    }

    def content_type_for(path)
      if ct = java.net.URLConnection.getFileNameMap.getContentTypeFor(path)
        return ct
      else
        ContentTypes[File.extname(path).downcase]
      end
    end

    def normalize_text(string)
      string.gsub("\302\240", ' '). # non-breaking space 00A0
             gsub(/\n|\t/, '').     # get rid of newlines/tabs
             strip
    end

    def logger_for(package_string)
      java.util.logging.Logger.getLogger(package_string)
    end

  end
end