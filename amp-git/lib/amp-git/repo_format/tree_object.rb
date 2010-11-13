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
        # = TreeObject
        #
        # This is a tree object representing a versioned directory. It has
        # a list of 
        class TreeObject < RawObject
          TreeEntry = Struct.new(:name, :mode, :ref)
          
          ##
          # Initializes the RawObject. Needs a hash to identify it and
          # an opener. The opener should point to the .git directory.
          #
          # @param [String] hsh the hash to use to find the object
          # @param [Support::RootedOpener] opener the opener to use to open the
          #   object file
          # @param [String] content if the content is known already, use
          #   the provided content instead
          def initialize(hsh, opener, content = nil)
            if content
              @hash_id, @opener = hsh, opener
              @type = 'tree'
              @content = content
            else
              super(hsh, opener)
            end
            parse!
          end
        
          ##
          # Returns a list of the names of the files/directories (blobs/trees) in the
          # tree
          #
          # @return [Array<String>] a (possibly unsorted) list of file and
          #   and directory names in this tree
          def entry_names
            @pairs.keys
          end
        
          ##
          # Returns the number of entries in the directory.
          #
          # @return [Fixnum] the number of entries in this directory
          def size
            @pairs.size
          end
          
          ##
          # Returns a TreeObject for the given filename in this level of
          # the tree.
          #
          # @param [String] name the name of the file to look up
          # @return [TreeEntry] the treeobject representing the file
          def tree_lookup(name)
            @pairs[name]
          end
        
          private
          
          def parse!
            require 'strscan'
            @pairs = {}
            scanner = StringScanner.new(@content)
            until scanner.eos?
              break unless scanner.scan(/(\d+) (\S+?)\x00(.{20})/m)
              new_entry = TreeEntry.new(scanner[2], scanner[1].to_i(8), NodeId.from_bin(scanner[3]))
              @pairs[new_entry.name] = new_entry
            end
          end
        
        end
      end
    end
  end
end
