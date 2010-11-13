puts 'Loading amp-git...'

require 'zlib'
require 'stringio'

# Must require the GitPicker or it won't be found.
require 'amp-front'
require 'amp-core'
require 'amp-git/repository'

module Amp
  module Git
    autoload :Changeset,                 'amp-git/repo_format/changeset.rb'
    autoload :WorkingDirectoryChangeset, 'amp-git/repo_format/changeset.rb'
    autoload :VersionedFile,             'amp-git/repo_format/versioned_file.rb'
    autoload :VersionedWorkingFile,      'amp-git/repo_format/versioned_file.rb'
  end
  module Core
    module Repositories
      module Git
        include Support
        autoload :LocalRepository,         'amp-git/repositories/local_repository.rb'
        autoload :NodeId,                  'amp-git/repo_format/node_id.rb'
        autoload :StagingArea,             'amp-git/repo_format/staging_area.rb'
        autoload :RawObject,               'amp-git/repo_format/raw_object.rb'
        autoload :LooseObject,             'amp-git/repo_format/loose_object.rb'
        autoload :TreeObject,              'amp-git/repo_format/tree_object.rb'
        autoload :CommitObject,            'amp-git/repo_format/commit_object.rb'
        autoload :TagObject,               'amp-git/repo_format/tag_object.rb'
        autoload :PackFile,                'amp-git/repo_format/packfile.rb'
        autoload :PackFileIndex,           'amp-git/repo_format/packfile_index.rb'
        autoload :PackFileIndexV1,         'amp-git/repo_format/packfile_index.rb'
        autoload :PackFileIndexV2,         'amp-git/repo_format/packfile_index.rb'
        autoload :Index,                   'amp-git/repo_format/index.rb'
        module Encoding                             
          autoload :BinaryDelta,           'amp-git/encoding/binary_delta.rb'
        end
      end
    end
  end
end

require 'amp-git/version'