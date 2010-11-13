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
# http://repo.or.cz/w/git.git?a=blob;f=Documentation/technical/pack-format.txt;h=1803e64e465fa4f8f0fe520fc0fd95d0c9def5bd;hb=HEAD
# http://git.rsbx.net/Documents/Git_Data_Formats.txt

module Amp
  module Core
    module Repositories    
      module Git
        ##
        # = PackFile
        #
        # Git uses it's "gc" command to pack loose objects into PackFiles.
        # This is one file, preferably with an index (though not requiring one),
        # which stores a number of objects in a very simple raw form.
        #
        # The index is *not* necessary. It is simply preferable because otherwise
        # you have to uncompress each object in a raw, then calculate the hash of
        # the object, just to find out where each object is and what its hash is.
        class PackFile
          include Amp::Core::Support
          ##
          # A single entry in a packfile. Dumb struct. However, it has some smart
          # class methods for parsing these bad boys in from a packfile. Take a
          # look at {#at} and {#read}.
          class PackFileEntry < Struct.new(:type, :size, :content, :hash_id, :reference, :offset, :delta_offset)
            include Amp::Core::Support
            class << self
              
              ##
              # Reads a {PackFileEntry} from the given file at a given offset. 
              # This is a helper method for the entry point for reading from an actual PackFile,
              # since often, you'll know where the entry will be located in the PackFile.
              #
              # @param [IO, #read] fp the file to read from
              # @return [PackFileEntry] an entry, decompressed and with its hash calculated.
              def at(fp, pos)
                fp.seek pos, IO::SEEK_SET
                read fp
              end
              
              ##
              # Reads a {PackFileEntry} from the given file. This is the entry point for
              # reading from an actual PackFile.
              #
              # @param [IO, #read] fp the file to read from
              # @return [PackFileEntry] an entry, decompressed and with its hash calculated.
              def read(fp)
                result = PackFileEntry.new
                result.offset = fp.pos
                result.type, result.size = read_header(fp)
                if result.type == OBJ_REF_DELTA
                  result.reference = fp.read(20)
                elsif result.type == OBJ_OFS_DELTA
                  result.delta_offset = result.offset - read_offset(fp)
                end
                result.content = read_data(fp, result.size)
                if result.type == OBJ_REF_DELTA
                  
                elsif result.type == OBJ_OFS_DELTA
                  cur = fp.tell
                  patch = Amp::Core::Repositories::Git::Encoding::BinaryDelta.new(result.content)
                  previous = self.at(fp, result.delta_offset)
                  result.content = patch.apply(previous.content)
                  result.size = result.content.size
                  result.type = previous.type
                  fp.seek(cur, IO::SEEK_SET)
                end
                result.calculate_hash!
                result
              end
              
              ##
              # Reads an OBJ_OFS_DELTA offset. N-bytes, encoded as a series of
              # bytes.  Each byte is shifted by (7 * n) bits, and added to the 
              # total. If the high bit (MSB) of a byte is 1, then another byte is
              # read, If it's 0, it stops.
              #
              # @param [IO, #read] fp the IO stream to read from
              # @return [Integer] the offset read
              def read_offset(fp)
                byte = Support::HexString.from_bin(fp.read(1)).ord
                tot = byte & 0x7f
                while (byte & 0x80) > 0
                  byte = Support::HexString.from_bin(fp.read(1)).ord
                  tot = ((tot + 1) << 7) | (byte & 0x7f)
                  break if (byte & 0x80) == 0
                end
                tot
              end
              
              ##
              # Reads in a PackFileEntry header from the file. This will get us the
              # type of the entry, as well as the size of its uncompressed data.
              #
              # @param [IO, #read] fp the file to read the header from
              # @return [Array(Integer, Integer)] the type and size of the entry packed
              #   into a tuple.
              def read_header(fp)
                tags = Support::HexString.from_bin(fp.read(1)).ord
                type = (tags & 0x70) >> 4
                size = tags & 0xF
                shift = 4
                while tags & 0x80 > 0
                  tags = Support::HexString.from_bin(fp.read(1)).ord
                  size += (tags & 0x7F) << shift
                  shift += 7
                end
                [type, size]
              end
              
              ##
              # Reads data from the file, uncompressing along the way, until +size+ bytes
              # have been decompressed. Since we don't know how much that will be ahead of time,
              # this is annoying slow. Oh wells.
              #
              # @param [IO, #read] fp the IO source to read compressed data from
              # @param [Integer] size the amount of uncompressed data to expect
              # @return [String] the uncompressed data
              def read_data(fp, size)
                result = ""
                z = Zlib::Inflate.new
                start = fp.tell
                while result.size < size && !z.stream_end?
                  result += z.inflate(fp.read(1))
                end
                # final bytes... can't predict this yet though it's usually 5 bytes
                while !fp.eof?
                  begin
                    result += z.finish
                    break
                  rescue Zlib::BufError
                    result += z.inflate(fp.read(1))
                  end
                end
                z.close
                result
              end
            end
            
            ##
            # Calculates the hash of this particular entry. We need to reconstruct the loose object
            # header to do this.
            def calculate_hash!
              prefix = PREFIX_NAME_LOOKUP[self.type]
              # add special cases for refs
              self.hash_id = NodeId.sha1("#{prefix} #{self.size}\0#{self.content}")
            end
            
            ##
            # Converts to an actual raw object.
            #
            # @param [Support::RootedOpener] an opener in case this object references other things....
            #   should usually be set
            # @return [RawObject] this entry in raw object form
            def to_raw_object(opener = nil)
              RawObject.construct(hash_id, opener, PREFIX_NAME_LOOKUP[type], content)
            end
          end
          
          attr_reader :index, :version, :size, :name
          
          OBJ_COMMIT = 1
          OBJ_TREE   = 2
          OBJ_BLOB   = 3
          OBJ_TAG    = 4
          OBJ_OFS_DELTA = 6
          OBJ_REF_DELTA = 7
          
          DATA_START_OFFSET = 12
          
          PREFIX_NAME_LOOKUP = {OBJ_COMMIT => 'commit', OBJ_TREE => 'tree', OBJ_BLOB => 'blob', OBJ_TAG => 'tag'}
          ##
          # Initializes a PackFile. Parses the header for some information but that's about it. It will
          # however determine if there is an index file, and if so, it will load that for
          # fast lookups later. It also verifies the fourcc of the packfile.
          #
          # @param [String] name the name of the packfile. This is relative to the directory it's in.
          # @param [Support::RootedOpener] opener an opener that should be relative to the .git directory.
          def initialize(name, opener)
            @name = name
            @opener = opener
            opener.open(name, "r") do |fp|
              # Check signature
              unless fp.read(4) == "PACK"
                raise ArgumentError.new("#{name} is not a packfile.")
              end
              @version = fp.read(4).unpack("N").first
              @size    = fp.read(4).unpack("N").first
              cur = fp.tell
              fp.seek(0, IO::SEEK_END)
              @end_of_data = fp.tell - 20
            end
            possible_index_path = name[0..(name.size - File.extname(name).size - 1)] + ".idx"
            if File.exist? possible_index_path
              # use a persistent file pointer
              fp = File.open(possible_index_path, "r")
              @index = PackFileIndex.parse(fp)
            end
            @offset_cache = {}
          end
          
          def cached_offset(given_hash)
            @offset_cache[given_hash]
          end
          
          def cache_entry(entry)
            @offset_cache[entry.hash_id] = entry.offset
          end
          
          ##
          # Gets an object in the Git system with the provided SHA1 hash identifier.
          # If this packfile has an associated index file, that will be used. Otherwise,
          # the packfile can be scanned from the beginning to the end, caching offsets as
          # it goes, enabling easy lookup later. Either way, a RawObject or a subclass of it
          # will be returned, or nil if no matching object is found.
          #
          # @param [String] given_hash the SHA-1 of the desired object
          # @return [RawObject] the object with the given ID. Nil if the object is not in the
          #   packfile.
          def object_for_hash(given_hash)
            @opener.open(name, "r") do |fp|
              given_hash.force_encoding("ASCII-8BIT") if given_hash.respond_to?(:force_encoding)
              entry = nil
              if index
                starting_at = index.offset_for_hash(given_hash)
                return PackFileEntry.at(starting_at, fp).to_raw_object
              else
                starting_at = cached_offset(given_hash) || DATA_START_OFFSET
                fp.seek(starting_at, IO::SEEK_SET)
                while fp.tell < @end_of_data
                  entry = PackFileEntry.read(fp)
                  cache_entry(entry)
                  return entry.to_raw_object if entry.hash_id == given_hash
                end
              end
            end
            nil
          end
          
        end
      end
    end
  end
end
