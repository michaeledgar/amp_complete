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
        # = CommitObject
        #
        # This is a commit object in the git system. This contains a reference to
        # a tree, one or more parents, an author, a committer, and a message. This
        # object is all you need to know everything about a commit.
        class CommitObject < RawObject
          attr_reader :tree_ref, :parent_refs, :author, :committer, :date, :message
          
          ##
          # Initializes the CommitObject. Needs a hash to identify it and
          # an opener. The opener should point to the .git directory. Immediately
          # parses the object.
          #
          # @param [String] hsh the hash to use to find the object
          # @param [Support::RootedOpener] opener the opener to use to open the
          #   object file
          # @param [String] content if the content is known already, use
          #   the provided content instead
          def initialize(hsh, opener, content = nil)
            if content
              @hash_id, @opener = hsh, opener
              @type = 'commit'
              @content = content
            else
              super(hsh, opener)
            end
            @parent_refs = []
            parse!
          end

          private
          
          ##
          # Parses the commit object into our attributes.
          def parse!
            lines = @content.split("\n")
            last_idx = 0
            lines.each_with_index do |line, idx|
              case line
              when /^tree (.{40})/
                @tree_ref = NodeId.from_hex($1)
              when /^parent (.{40})/
                @parent_refs << NodeId.from_hex($1)
              when /^author #{AUTHOR_MATCH}/
                @author = "#{$1} <#{$2}>"
                @date = Time.at($3.to_i)
              when /^committer #{AUTHOR_MATCH}/
                @committer = "#{$1} <#{$2}>"
                @date = Time.at($3.to_i)
              when ""
                last_idx = idx + 1
                break
              end
            end
            @message = lines[last_idx..-1].join("\n")
          end
        
        end
      end
    end
  end
end
