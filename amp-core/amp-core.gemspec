# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{amp-core}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Edgar"]
  s.date = %q{2010-11-12}
  s.description = %q{Amp's required plugin, providing core functionality (such as repository detection
and amp-specific command validations) to all other plugins.
}
  s.email = %q{michael.j.edgar@dartmouth.edu}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "Ampfile",
     "Gemfile",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "features/amp-core.feature",
     "features/step_definitions/amp-core_steps.rb",
     "features/support/env.rb",
     "lib/amp-core.rb",
     "lib/amp-core/amp_plugin.rb",
     "lib/amp-core/command_ext/repository_loading.rb",
     "lib/amp-core/commands/info.rb",
     "lib/amp-core/commands/root.rb",
     "lib/amp-core/repository/abstract/abstract_changeset.rb",
     "lib/amp-core/repository/abstract/abstract_local_repo.rb",
     "lib/amp-core/repository/abstract/abstract_staging_area.rb",
     "lib/amp-core/repository/abstract/abstract_versioned_file.rb",
     "lib/amp-core/repository/abstract/common_methods/changeset.rb",
     "lib/amp-core/repository/abstract/common_methods/local_repo.rb",
     "lib/amp-core/repository/abstract/common_methods/staging_area.rb",
     "lib/amp-core/repository/abstract/common_methods/versioned_file.rb",
     "lib/amp-core/repository/generic_repo_picker.rb",
     "lib/amp-core/repository/repository.rb",
     "lib/amp-core/support/encoding_utils.rb",
     "lib/amp-core/support/hex_string.rb",
     "lib/amp-core/support/platform_utils.rb",
     "lib/amp-core/support/rooted_opener.rb",
     "lib/amp-core/support/ruby_version_utils.rb",
     "lib/amp-core/templates/git/blank.log.erb",
     "lib/amp-core/templates/git/default.log.erb",
     "lib/amp-core/templates/mercurial/blank.commit.erb",
     "lib/amp-core/templates/mercurial/blank.log.erb",
     "lib/amp-core/templates/mercurial/default.commit.erb",
     "lib/amp-core/templates/mercurial/default.log.erb",
     "lib/amp-core/templates/template.rb",
     "spec/command_ext_specs/repository_loading_spec.rb",
     "spec/command_ext_specs/spec_helper.rb",
     "spec/plugin_spec.rb",
     "spec/repository_specs/repository_spec.rb",
     "spec/repository_specs/spec_helper.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/support_specs/encoding_utils_spec.rb",
     "spec/support_specs/hex_string_spec.rb",
     "spec/support_specs/platform_utils_spec.rb",
     "spec/support_specs/ruby_version_utils_spec.rb",
     "spec/support_specs/spec_helper.rb",
     "test/test_templates.rb"
  ]
  s.homepage = %q{http://github.com/michaeledgar/amp-core}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{The core plugin for Amp. Necessary for Amp to function.}
  s.test_files = [
    "spec/command_ext_specs/repository_loading_spec.rb",
     "spec/command_ext_specs/spec_helper.rb",
     "spec/plugin_spec.rb",
     "spec/repository_specs/repository_spec.rb",
     "spec/repository_specs/spec_helper.rb",
     "spec/spec_helper.rb",
     "spec/support_specs/encoding_utils_spec.rb",
     "spec/support_specs/hex_string_spec.rb",
     "spec/support_specs/platform_utils_spec.rb",
     "spec/support_specs/ruby_version_utils_spec.rb",
     "spec/support_specs/spec_helper.rb",
     "test/test_templates.rb"
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

