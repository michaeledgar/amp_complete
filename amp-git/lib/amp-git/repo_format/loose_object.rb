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
        class LooseObject < RawObject
          
          class << self
            
            def lookup(hsh, opener)
              require 'scanf'
              path = File.join("objects", hsh[0..1], hsh[2..40])
              mode = "r"
              type, content = nil, nil
              begin
                opener.open(path, mode) do |fp|
                  type, content_size = fp.scanf("%s %d")
                  fp.seek(type.size + 1 + content_size.to_s.size + 1, IO::SEEK_SET)
                  content = fp.read(content_size)
                end
              rescue SystemCallError
                if create
                  FileUtils.mkdir_p(opener.join("objects", hsh[0..1]))
                  mode = "w+"
                  retry
                else
                  raise
                end
              end
              
              RawObject.construct(hsh, opener, type, content)
            end
          end
          
          attr_accessor :type
          
          ##
          # Initializes the RawObject. Needs a hash to identify it and
          # an opener. The opener should point to the .git directory.
          #
          # @param [String] hsh the hash to use to find the object
          # @param [Support::RootedOpener] opener the opener to use to open the
          #   object file
          def initialize(hsh, opener, content = nil)
            @hash_id, @opener, @content = hsh, opener, content
          end
        
        end
      end
    end
  end
end
