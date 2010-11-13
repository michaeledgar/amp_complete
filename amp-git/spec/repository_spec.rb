##################################################################
#                  Licensing Information                         #
#                                                                #
#  The following code is licensed, as standalone code, under     #
#  the Ruby License, unless otherwise directed within the code.  #
#                                                                #
#  For information on the license of this code when distributed  #
#  with and used in conjunction with the other modules in the    #
#  Amp project, please see the root-level LICENSE file.          #
#                                                                #
#  © Michael J. Edgar and Ari Brown, 2009-2010                   #
#                                                                #
##################################################################

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Amp::Core::Repositories::Git::GitPicker do
  include ::Construct::Helpers
  describe '#repo_in_dir?' do
    it 'returns true if there is a .git directory' do
      within_construct do |c|
        c.directory 'my_repo' do |dir|
          dir.directory '.git' do |final|
            Amp::Core::Repositories::Git::GitPicker.new.repo_in_dir?(final.to_s).should be_true
          end
        end
      end
    end
    
    it 'returns false if there is no .git directory' do
      within_construct do |c|
        c.directory 'my_repo' do |dir|
          dir.directory '.hg'
          dir.directory '.svn'
          Amp::Core::Repositories::Git::GitPicker.new.repo_in_dir?(dir.to_s).should be_false
        end
      end
    end
  end
  
  describe '#pick' do
    it 'returns a LocalRepository object' do
      within_construct do |c|
        c.directory 'my_repo' do |dir|
          dir.directory '.git'
          repo = Amp::Core::Repositories::Git::GitPicker.new.pick({}, dir.to_s)
          repo.should be_a(Amp::Core::Repositories::Git::LocalRepository)
        end
      end
    end
    
    it 'returns nil when no .git found' do
      within_construct do |c|
        c.directory 'my_repo' do |dir|
          dir.directory '.hg'
          dir.directory '.svn'
          lambda {
            repo = Amp::Core::Repositories::Git::GitPicker.new.pick({}, dir.to_s)
          }.should raise_error(ArgumentError)
        end
      end
    end
  end
  
  it 'is used by Amp::Core::Repositories.pick' do
    within_construct do |c|
      c.directory 'my_repo' do |dir|
        dir.directory '.git'
        repo = Amp::Core::Repositories.pick({}, dir.to_s)
        repo.should be_a(Amp::Core::Repositories::Git::LocalRepository)
      end
    end
  end
end