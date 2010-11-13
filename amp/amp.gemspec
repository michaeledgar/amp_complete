# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{amp}
  s.version = "0.5.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Edgar"]
  s.date = %q{2010-11-13}
  s.default_executable = %q{amp}
  s.description = %q{This package is a small wrapper around several core amp plugins.}
  s.email = %q{michael.j.edgar@dartmouth.edu}
  s.executables = ["amp"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.homepage = %q{http://github.com/michaeledgar/amp}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A meta-VCS in Ruby, harnessing Ruby's strengths.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<amp-front>, [">= 0.1.0"])
      s.add_runtime_dependency(%q<amp-core>, [">= 0.1.0"])
      s.add_runtime_dependency(%q<amp-git>, [">= 0.1.0"])
      s.add_runtime_dependency(%q<amp-hg>, [">= 0.1.0"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<metric_fu>, [">= 0"])
    else
      s.add_dependency(%q<amp-front>, [">= 0.1.0"])
      s.add_dependency(%q<amp-core>, [">= 0.1.0"])
      s.add_dependency(%q<amp-git>, [">= 0.1.0"])
      s.add_dependency(%q<amp-hg>, [">= 0.1.0"])
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<metric_fu>, [">= 0"])
    end
  else
    s.add_dependency(%q<amp-front>, [">= 0.1.0"])
    s.add_dependency(%q<amp-core>, [">= 0.1.0"])
    s.add_dependency(%q<amp-git>, [">= 0.1.0"])
    s.add_dependency(%q<amp-hg>, [">= 0.1.0"])
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<metric_fu>, [">= 0"])
  end
end
