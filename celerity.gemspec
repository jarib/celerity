# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{celerity}
  s.version = "0.0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jari Bakken", "T. Alexander Lystad", "Knut Johannes Dahle"]
  s.date = %q{2009-03-28}
  s.description = %q{Celerity is a JRuby wrapper around HtmlUnit – a headless Java browser with JavaScript support. It provides a simple API for programmatic navigation through web applications. Celerity aims at being API compatible with Watir.}
  s.email = %q{jari.bakken@finn.no}
  s.extra_rdoc_files = ["History.txt", "License.txt", "README.txt"]
  s.files = ["History.txt", "lib", "lib/celerity", "lib/celerity.rb", "lib/celerity/browser.rb", "lib/celerity/clickable_element.rb", "lib/celerity/collections.rb", "lib/celerity/container.rb", "lib/celerity/default_viewer.rb", "lib/celerity/disabled_element.rb", "lib/celerity/element.rb", "lib/celerity/element_collection.rb", "lib/celerity/element_locator.rb", "lib/celerity/elements", "lib/celerity/elements/button.rb", "lib/celerity/elements/file_field.rb", "lib/celerity/elements/form.rb", "lib/celerity/elements/frame.rb", "lib/celerity/elements/image.rb", "lib/celerity/elements/label.rb", "lib/celerity/elements/link.rb", "lib/celerity/elements/meta.rb", "lib/celerity/elements/non_control_elements.rb", "lib/celerity/elements/option.rb", "lib/celerity/elements/radio_check.rb", "lib/celerity/elements/select_list.rb", "lib/celerity/elements/table.rb", "lib/celerity/elements/table_cell.rb", "lib/celerity/elements/table_elements.rb", "lib/celerity/elements/table_row.rb", "lib/celerity/elements/text_field.rb", "lib/celerity/exception.rb", "lib/celerity/extra", "lib/celerity/extra/method_generator.rb", "lib/celerity/htmlunit", "lib/celerity/htmlunit.rb", "lib/celerity/htmlunit/commons-codec-1.3.jar", "lib/celerity/htmlunit/commons-collections-3.2.1.jar", "lib/celerity/htmlunit/commons-httpclient-3.1.jar", "lib/celerity/htmlunit/commons-io-1.4.jar", "lib/celerity/htmlunit/commons-lang-2.4.jar", "lib/celerity/htmlunit/commons-logging-1.1.1.jar", "lib/celerity/htmlunit/cssparser-0.9.5.jar", "lib/celerity/htmlunit/htmlunit-2.5-SNAPSHOT.jar", "lib/celerity/htmlunit/htmlunit-core-js-2.5-SNAPSHOT.jar", "lib/celerity/htmlunit/nekohtml-1.9.12-20090308.130127-11.jar", "lib/celerity/htmlunit/sac-1.3.jar", "lib/celerity/htmlunit/serializer-2.7.1.jar", "lib/celerity/htmlunit/xalan-2.7.1.jar", "lib/celerity/htmlunit/xercesImpl-2.8.1.jar", "lib/celerity/htmlunit/xml-apis-1.3.04.jar", "lib/celerity/identifier.rb", "lib/celerity/input_element.rb", "lib/celerity/listener.rb", "lib/celerity/resources", "lib/celerity/resources/no_viewer.png", "lib/celerity/util.rb", "lib/celerity/version.rb", "lib/celerity/watir_compatibility.rb", "License.txt", "Rakefile", "README.txt", "tasks", "tasks/jar.rake", "tasks/rdoc.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://celerity.rubyforge.org}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{celerity}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Celerity is a JRuby library for easy and fast functional test automation for web applications}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 1.11.0"])
    else
      s.add_dependency(%q<hoe>, [">= 1.11.0"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.11.0"])
  end
end
