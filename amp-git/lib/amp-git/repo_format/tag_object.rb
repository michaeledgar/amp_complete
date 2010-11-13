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
        # = TagObject
        #
        # This is a formal tag object in the commit system. Most tags actually don't
        # involve one of these objects - they just create a ref (alias) to a commit
        # object. This tag will also reference a (usually) commit object, but they
        # can contain their own messages, including PGP signatures. And honestly,
        # we just have to suck it up and support them.
        class TagObject < RawObject
          attr_reader :object_ref, :reffed_type, :tag, :tagger, :date, :message
          
          ##
          # Initializes the TagObject. Needs a hash to identify it and
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
              @type = 'tag'
              @content = content
            else
              super(hsh, opener)
            end
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
              when /^object (.{40})/
                @object_ref = NodeId.from_hex($1)
              when /^type (\S+)/
                @reffed_type = $1
              when /^tag\s+(.*)\s*$/
                @tag = $1
              when /^tagger #{AUTHOR_MATCH}/
                @tagger = "#{$1} <#{$2}>"
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
