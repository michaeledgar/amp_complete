gem 'rdoc', '>= 2.4.2'
require 'rdoc'

require 'rake'
require 'rdoc/task'
require 'rake/gempackagetask'

PROJECTS = %w(amp-front amp-core amp-git amp-hg amp)

desc 'Run all tests by default'
task :default => %w(test)

%w(test package gem).each do |task_name|
  desc "Run #{task_name} task for all projects"
  task task_name do
    errors = []
    PROJECTS.each do |project|
      system(%(cd #{project} && #{$0} #{task_name})) || errors << project
    end
    fail("Errors in #{errors.join(', ')}") unless errors.empty?
  end
end

desc "Release all components to gemcutter."
task :release => :package do
  errors = []
  PROJECTS.each do |project|
    system(%(cd #{project} && #{$0} release)) || errors << project
  end
  fail("Errors in #{errors.join(', ')}") unless errors.empty?
end

desc "Install gems for all projects."
task :install => :gem do
  version = File.read("VERSION").strip
  PROJECTS.each do |project|
    puts "INSTALLING #{project}"
    system("gem install #{project}/pkg/#{project}-#{version}.gem --no-ri --no-rdoc")
  end
end


desc 'Bump all versions to match version.rb'
task :update_versions do
  canonical = File.dirname(__FILE__) + '/amp/lib/amp/version.rb'
  require canonical

  File.open("AMP_VERSION", "w") do |f|
    f.write Amp::VERSION + "\n"
  end

  constants = {
    'amp-front' => 'Amp::Front',
    'amp-core'  => 'Amp::Core',
    'amp-hg'    => 'Amp::Mercurial',
    'amp-git'   => 'Amp::Git',
  }

  version_file = File.read(canonical)
  p version_file

  (PROJECTS - ['amp']).each do |project|
    Dir["#{project}/lib/*/version.rb"].each do |file|
      File.open(file, 'w') do |f|
        f.write version_file.gsub(/Amp/, constants[project])
      end
    end
  end
end