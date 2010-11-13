# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{amp-git}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Edgar"]
  s.date = %q{2010-11-11}
  s.description = %q{This gem provides git support to Amp. It is bundled with Amp itself.}
  s.email = %q{michael.j.edgar@dartmouth.edu}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "Gemfile",
     "Gemfile.lock",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "features/amp-git.feature",
     "features/step_definitions/amp-git_steps.rb",
     "features/support/env.rb",
     "lib/amp-git.rb",
     "lib/amp-git/amp_plugin.rb",
     "lib/amp-git/encoding/binary_delta.rb",
     "lib/amp-git/repo_format/changeset.rb",
     "lib/amp-git/repo_format/commit_object.rb",
     "lib/amp-git/repo_format/index.rb",
     "lib/amp-git/repo_format/loose_object.rb",
     "lib/amp-git/repo_format/node_id.rb",
     "lib/amp-git/repo_format/packfile.rb",
     "lib/amp-git/repo_format/packfile_index.rb",
     "lib/amp-git/repo_format/raw_object.rb",
     "lib/amp-git/repo_format/staging_area.rb",
     "lib/amp-git/repo_format/tag_object.rb",
     "lib/amp-git/repo_format/tree_object.rb",
     "lib/amp-git/repo_format/versioned_file.rb",
     "lib/amp-git/repositories/local_repository.rb",
     "lib/amp-git/repository.rb",
     "spec/amp-git_spec.rb",
     "spec/repo_format/node_id_spec.rb",
     "spec/repo_format/spec_helper.rb",
     "spec/repository_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "test/index_tests/index",
     "test/index_tests/test_helper.rb",
     "test/index_tests/test_index.rb",
     "test/packfile_tests/hasindex.idx",
     "test/packfile_tests/hasindex.pack",
     "test/packfile_tests/pack-4e1941122fd346526b0a3eee2d92f3277a0092cd.pack",
     "test/packfile_tests/pack-d23ff2538f970371144ae7182c28730b11eb37c1.idx",
     "test/packfile_tests/test_helper.rb",
     "test/packfile_tests/test_packfile.rb",
     "test/packfile_tests/test_packfile_index_v2.rb",
     "test/packfile_tests/test_packfile_with_index.rb",
     "test/test_commit_object.rb",
     "test/test_git_delta.rb",
     "test/test_helper.rb",
     "test/test_loose_object.rb",
     "test/test_tag_object.rb",
     "test/test_tree_object.rb"
  ]
  s.homepage = %q{http://github.com/michaeledgar/amp-git}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{The git plugin for Amp.}
  s.test_files = [
    "spec/amp-git_spec.rb",
     "spec/repo_format/node_id_spec.rb",
     "spec/repo_format/spec_helper.rb",
     "spec/repository_spec.rb",
     "spec/spec_helper.rb",
     "test/index_tests/test_helper.rb",
     "test/index_tests/test_index.rb",
     "test/packfile_tests/test_helper.rb",
     "test/packfile_tests/test_packfile.rb",
     "test/packfile_tests/test_packfile_index_v2.rb",
     "test/packfile_tests/test_packfile_with_index.rb",
     "test/test_commit_object.rb",
     "test/test_git_delta.rb",
     "test/test_helper.rb",
     "test/test_loose_object.rb",
     "test/test_tag_object.rb",
     "test/test_tree_object.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<amp-front>, [">= 0.1.0"])
      s.add_runtime_dependency(%q<amp-core>, [">= 0.1.0"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<minitest>, [">= 1.7"])
      s.add_development_dependency(%q<devver-construct>, [">= 1.1.0"])
    else
      s.add_dependency(%q<amp-front>, [">= 0.1.0"])
      s.add_dependency(%q<amp-core>, [">= 0.1.0"])
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<minitest>, [">= 1.7"])
      s.add_dependency(%q<devver-construct>, [">= 1.1.0"])
    end
  else
    s.add_dependency(%q<amp-front>, [">= 0.1.0"])
    s.add_dependency(%q<amp-core>, [">= 0.1.0"])
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<minitest>, [">= 1.7"])
    s.add_dependency(%q<devver-construct>, [">= 1.1.0"])
  end
end
