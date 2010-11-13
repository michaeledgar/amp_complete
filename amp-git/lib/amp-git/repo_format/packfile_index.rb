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
# http://book.git-scm.com/7_the_packfile.html
# http://git.rsbx.net/Documents/Git_Data_Formats.txt
# http://repo.or.cz/w/git.git?a=blob;f=Documentation/technical/pack-format.txt;h=1803e64e465fa4f8f0fe520fc0fd95d0c9def5bd;hb=HEAD

module Amp
  module Core
    module Repositories    
      module Git
        class PackFileIndexLookupError < StandardError; end
        ##
        # = PackFile
        #
        # Git uses it's "gc" command to pack loose objects into PackFiles.
        # This is one file, preferably with an index (though not requiring one),
        # which stores a number of objects in a very simple raw form.
        #
        # This class handles the index file, which is used for fast lookups of
        # entries in packfiles. They use fanouts to make searching very simple.
        #
        # The fanout values are interesting - they are the number of entries with a first sha1
        # byte less than or equal to the byte provided. So if the only sha1s you can
        # find in a given packfile are 00112233.... and 020304.... then the first few
        # fanouts are:
        # fanout[0] = 1
        # fanout[1] = 1
        # fanout[2] = 2
        # ....
        # fanout[254] = 2
        class PackFileIndex
          
          class << self
            ##
            # Initializes the index file by reading from an input source.  Does not
            # automatically read in any actual data, but instead finds the necessary
            # values to make searching by SHA1 quick.
            #
            # @param [IO, #read] fp an input stream at the beginning of the index
            def parse(fp)
              fourcc = fp.read(4)
              if fourcc == "\xfftOc"
                version = fp.read(4).unpack("N").first
                PackFileIndexV2.new(fp) if version == 2
              else
                fp.seek(-4, IO::SEEK_CUR)
                PackFileIndexV1.new(fp)
              end
            end
          end
          
          FANOUT_TABLE_SIZE = 4 * 256

          # Common PackFileIndex methods
          attr_reader :size
          attr_reader :fanout

          # Common initialization code
          # @param [IO, #read] fp input stream to read the file from
          def initialize(fp)
            @fp = fp
            @fanout = @fp.read(FANOUT_TABLE_SIZE).unpack("N256")
            @size = @fanout[255]
          end
          
          ##
          # uses fanout logic to determine the indices in which the desired
          # hash might be found. This range can be searched to find the hash.
          def search_range_for_hash(hash)
            byte = Support::HexString.from_bin(hash).ord
            min = byte > 0 ? (fanout[byte - 1]) : 0
            max = fanout[byte]
            min...max
          end
        end
        
        ##
        # This class is for the older version of index files. They are
        # structured as simply a fanout table and a list of [offset][sha1] entries.
        # There's a checksum at the bottom for verification.
        #
        # Initialization only reads in the fanout table, and the file is left open.
        class PackFileIndexV1 < PackFileIndex
          ENTRY_TABLE_START = 256 * 4
          ENTRY_TABLE_ENTRY_SIZE = 20 + 4
          ENTRY_TABLE_FORMAT = "Na20"
          
          ##
          # Looks up the offset in a packfile of a given hash. nil is returned if
          # the sha1 isn't found.
          #
          # @param [String] hsh a binary, sha-1 hash of the desired object
          # @return [Fixnum, nil] the offset into the corresponding packfile at which you
          #  can find the object
          def offset_for_hash(hsh)
            range = search_range_for_hash hsh
            @fp.seek(FANOUT_TABLE_START + range.begin * ENTRY_TABLE_ENTRY_SIZE, IO::SEEK_SET)
            # linear search for now.
            # TODO: binary search!
            range.each do |_|
              offset, sha1 = @fp.read(ENTRY_TABLE_ENTRY_SIZE).unpack(ENTRY_TABLE_FORMAT)
              return offset if sha1 == hsh
            end
            raise PackFileIndexLookupError.new("Couldn't find the hash #{hsh.inspect} in the packfile index.")
          end
        end
        
        ##
        # This class is for the older version of index files. They are
        # structured as simply a fanout table and a list of [offset][sha1] entries.
        # There's a checksum at the bottom for verification.
        #
        # Initialization only reads in the fanout table, and the file is left open.
        class PackFileIndexV2 < PackFileIndex
          ENTRY_TABLE_START = 256 * 4 + 8
          SHA1_FORMAT = "a20"
          SHA1_SIZE = 20
          
          def sha1_table_offset
            ENTRY_TABLE_START
          end
          
          def crc_table_offset
            ENTRY_TABLE_START + size * SHA1_SIZE
          end
          
          def offset_table_offset
            crc_table_offset + size * 4
          end
          
          def big_offset_table_offset
            offset_table_offset + size * 4
          end
          
          ##
          # Looks up the offset in a packfile of a given hash. nil is returned if
          # the sha1 isn't found.
          #
          # @param [String] hsh a binary, sha-1 hash of the desired object
          # @return [Fixnum, nil] the offset into the corresponding packfile at which you
          #  can find the object
          def offset_for_hash(hsh)
            range = search_range_for_hash hsh
            @fp.seek(sha1_table_offset + range.begin * SHA1_SIZE, IO::SEEK_SET)
            # linear search for now.
            # TODO: binary search!
            range.each do |idx|
              sha1 = @fp.read(SHA1_SIZE).unpack(SHA1_FORMAT).first # sha1s are 20 bytes
              return offset_for_index(idx) if sha1 == hsh.to_bin
            end
            raise PackFileIndexLookupError.new("Couldn't find the hash #{hsh.inspect} in the packfile index.")
          end
          
          ##
          # Looks up the offset of an object given its index in the file. This index
          # is assumed to have been determined by matching the sha1 of the object to
          # a sha1 in the SHA1 table of the index.
          #
          # This requires a little more advanced logic because there is an offset table,
          # and a 64-bit offset table. The normal offset table only supports 31-bit offsets,
          # if the high bit is set, then the 31-bit value is actually an index into the big
          # offset table.
          #
          # @param [Integer] idx the index into the offset table
          # @return [Integer] the offset in the packfile where you can find the object with
          #   the given index into the index
          def offset_for_index(idx)
            @fp.seek(offset_table_offset + 4 * idx, IO::SEEK_SET)
            offset = @fp.read(4).unpack("N").first
            if offset & 0x80000000 != 0
              @fp.seek(big_offset_table_offset + 8 * (offset & 0x7fffffff))
              offset = Support::EncodingUtils.network_to_host_64(@fp.read(8).unpack("Q").first)
            end
            offset
          end
        end
      end
    end
  end
end
