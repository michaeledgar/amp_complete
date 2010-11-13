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

# This was written by reading the Git Book. No source code was
# examined to produce this code. It is the original work of its
# creators, Michael Edgar and Ari Brown.
#
# http://book.git-scm.com/7_how_git_stores_objects.html

module Amp
  module Core
    module Repositories    
      module Git
        ##
        # = LooseObject
        #
        # A single loose object (tree, tag, commit, etc.) in the Git system.
        # Its type and content will be determined after we read the file.
        #
        # It is uniquely identified by a SHA1 hash.
        class RawObject
          attr_reader :type, :content, :hash_id
          AUTHOR_MATCH = /([^<]*) <(.*)> (\d+) ([-+]?\d+)/
          class << self
            
            
            def for_hash(hsh, git_opener)
              # no way to handle packed objects yet
              LooseObject.lookup(hsh, git_opener)
            end
            
            def construct(hsh, opener, type, content)
              # type, content should both be set now
              type_lookup = {'tree' => TreeObject, 'commit' => CommitObject, 'tag' => TagObject}
              object_klass = type_lookup[type] || LooseObject
              result = object_klass.new(hsh, opener, content)
              result.type = type if object_klass == LooseObject
              result
            end
          end
        end
      end
    end
  end
end
