# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{amp-front}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Edgar"]
  s.date = %q{2010-11-11}
  s.description = %q{The generic front-end used by Amp. May be completely published as a generic library in the future, at which point a name change will be necessary.}
  s.email = %q{michael.j.edgar@dartmouth.edu}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "Ampfile",
     "Gemfile",
     "Gemfile.lock",
     "LICENSE",
     "README.md",
     "Rakefile",
     "VERSION",
     "design_docs/commands.md",
     "design_docs/dependencies.md",
     "design_docs/plugins.md",
     "features/amp.feature",
     "features/amp_help.feature",
     "features/amp_plugin_list.feature",
     "features/step_definitions/amp-front_steps.rb",
     "features/support/env.rb",
     "lib/amp-front.rb",
     "lib/amp-front/dispatch/commands/base.rb",
     "lib/amp-front/dispatch/commands/builtin/help.rb",
     "lib/amp-front/dispatch/commands/builtin/plugin.rb",
     "lib/amp-front/dispatch/commands/validations.rb",
     "lib/amp-front/dispatch/runner.rb",
     "lib/amp-front/help/entries/__default__.erb",
     "lib/amp-front/help/entries/ampfiles.md",
     "lib/amp-front/help/entries/commands.erb",
     "lib/amp-front/help/entries/new-commands.md",
     "lib/amp-front/help/help.rb",
     "lib/amp-front/plugins/base.rb",
     "lib/amp-front/support/module_extensions.rb",
     "lib/amp-front/third_party/maruku.rb",
     "lib/amp-front/third_party/maruku/attributes.rb",
     "lib/amp-front/third_party/maruku/defaults.rb",
     "lib/amp-front/third_party/maruku/errors_management.rb",
     "lib/amp-front/third_party/maruku/helpers.rb",
     "lib/amp-front/third_party/maruku/input/charsource.rb",
     "lib/amp-front/third_party/maruku/input/extensions.rb",
     "lib/amp-front/third_party/maruku/input/html_helper.rb",
     "lib/amp-front/third_party/maruku/input/linesource.rb",
     "lib/amp-front/third_party/maruku/input/parse_block.rb",
     "lib/amp-front/third_party/maruku/input/parse_doc.rb",
     "lib/amp-front/third_party/maruku/input/parse_span_better.rb",
     "lib/amp-front/third_party/maruku/input/rubypants.rb",
     "lib/amp-front/third_party/maruku/input/type_detection.rb",
     "lib/amp-front/third_party/maruku/input_textile2/t2_parser.rb",
     "lib/amp-front/third_party/maruku/maruku.rb",
     "lib/amp-front/third_party/maruku/output/to_ansi.rb",
     "lib/amp-front/third_party/maruku/output/to_html.rb",
     "lib/amp-front/third_party/maruku/output/to_markdown.rb",
     "lib/amp-front/third_party/maruku/output/to_s.rb",
     "lib/amp-front/third_party/maruku/string_utils.rb",
     "lib/amp-front/third_party/maruku/structures.rb",
     "lib/amp-front/third_party/maruku/structures_inspect.rb",
     "lib/amp-front/third_party/maruku/structures_iterators.rb",
     "lib/amp-front/third_party/maruku/textile2.rb",
     "lib/amp-front/third_party/maruku/toc.rb",
     "lib/amp-front/third_party/maruku/usage/example1.rb",
     "lib/amp-front/third_party/maruku/version.rb",
     "lib/amp-front/third_party/trollop.rb",
     "spec/amp-front_spec.rb",
     "spec/command_specs/base_spec.rb",
     "spec/command_specs/command_spec.rb",
     "spec/command_specs/help_spec.rb",
     "spec/command_specs/spec_helper.rb",
     "spec/command_specs/validations_spec.rb",
     "spec/dispatch_specs/runner_spec.rb",
     "spec/dispatch_specs/spec_helper.rb",
     "spec/help_specs/help_entry_spec.rb",
     "spec/help_specs/help_registry_spec.rb",
     "spec/help_specs/spec_helper.rb",
     "spec/plugin_specs/base_spec.rb",
     "spec/plugin_specs/spec_helper.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/support_specs/module_extensions_spec.rb",
     "spec/support_specs/spec_helper.rb",
     "test/third_party_tests/test_trollop.rb"
  ]
  s.homepage = %q{http://github.com/michaeledgar/amp-front}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Generic front-end for Amp.}
  s.test_files = [
    "spec/amp-front_spec.rb",
     "spec/command_specs/base_spec.rb",
     "spec/command_specs/command_spec.rb",
     "spec/command_specs/help_spec.rb",
     "spec/command_specs/spec_helper.rb",
     "spec/command_specs/validations_spec.rb",
     "spec/dispatch_specs/runner_spec.rb",
     "spec/dispatch_specs/spec_helper.rb",
     "spec/help_specs/help_entry_spec.rb",
     "spec/help_specs/help_registry_spec.rb",
     "spec/help_specs/spec_helper.rb",
     "spec/plugin_specs/base_spec.rb",
     "spec/plugin_specs/spec_helper.rb",
     "spec/spec_helper.rb",
     "spec/support_specs/module_extensions_spec.rb",
     "spec/support_specs/spec_helper.rb",
     "test/third_party_tests/test_trollop.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
  end
end
