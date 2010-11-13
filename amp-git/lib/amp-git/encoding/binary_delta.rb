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
# http://git.rsbx.net/Documents/Git_Data_Formats.txt

module Amp
  module Core
    module Repositories
      module Git
        
        ##
        # All of git's specific encoding classes.
        module Encoding
          class DeltaError < StandardError; end
          
          ##
          # Handles the binary delta format that are found in Git's packfiles.
          # The format is detailed in the link above.
          class BinaryDelta
            attr_accessor :base_length, :result_length, :hunks
            
            ##
            # Parses a git-format binary delta from a string.
            #
            # @param [String] delta the delta to parse
            def initialize(delta)
              fp = StringIO.new(delta)
              @base_length = read_little_endian_base128(fp)
              @result_length = read_little_endian_base128(fp)
              @hunks = []
              while !fp.eof?
                @hunks << Hunk.parse(fp)
              end
            end
            
            ##
            # Applies the binary delta to an original text. Returns the patched
            # data.
            #
            # @param [String] original the text to patch with the delta
            # @return the patched data
            def apply(original)
              if original.size != @base_length
                raise DeltaError.new("Expected input data to be #{@base_length} bytes, but was #{original.size} bytes.")
              end
              output = StringIO.new
              output.string.force_encoding('BINARY') if output.string.respond_to?(:force_encoding)
              @hunks.each do |hunk|
                hunk.apply(output, original)
              end
              if output.string.size != @result_length
                raise DeltaError.new("Expected patched data to be #{@result_length} bytes, but was #{output.string.size} bytes.")
              end
              output.string
            end
            
            private
            
            ##
            # Reads a little endian, base-128 value from a stream.
            # This is a variable-length integer, where bytes 0 to N-1 have an MSB
            # of 1, and byte N has an MSB of 0.
            #
            # @param [IO, #read] fp the input stream to read the value from
            # @return [Integer] the encoded integer
            def read_little_endian_base128(fp)
              result = shift = 0
              begin
                byte = Support::HexString.from_bin(fp.read(1)).ord
                result |= (byte & 0x7f) << shift
                shift += 7
              end while byte & 0x80 > 0
              result
            end
            
            ##
            # @api private
            class Hunk
              ##
              # Parses a hunk from the input stream. Each hunk is an action: either a
              # a copy from an input stream, or an "insert" which inserts specified
              # data.
              def self.parse(fp)
                opcode = Support::HexString.from_bin(fp.read(1)).ord
                if opcode & 0x80 == 0
                  InsertHunk.new(opcode, fp)
                else
                  CopyHunk.new(opcode, fp)
                end
              end
            end
            
            ##
            # A Hunk that performs an insert operation.  One of two types of delta
            # hunks in the git binary delta format.
            class InsertHunk
              ##
              # Creates a new insert hunk.
              #
              # @param [Fixnum] opcode the opcode that identifies this hunk's properties.
              # @param [IO, #read] fp the input stream we're reading this delta from
              def initialize(opcode, fp)
                @data = fp.read(opcode & 0x7f)
              end
              
              ##
              # Applies the Hunk with a given output buffer with an input string.
              #
              # @param [IO, #write] output the output buffer we're building up
              # @param [String] input the original data. ignored for InsertHunk.
              def apply(output, input)
                output.write @data
              end
            end
            
            ##
            # A Hunk that performs a copy operation.  One of two types of delta
            # hunks in the git binary delta format.
            class CopyHunk
              ##
              # Creates a new copy hunk.
              #
              # @param [Fixnum] opcode the opcode that identifies this hunk's properties.
              # @param [IO, #read] fp the input stream we're reading this delta from
              def initialize(opcode, fp)
                @offset = @length = 0
                shift = 0
                0.upto(3) do
                  @offset |= Support::HexString.from_bin(fp.read(1)).ord << shift if opcode & 0x01 > 0
                  opcode >>= 1
                  shift += 8
                end
                shift = 0
                0.upto(2) do
                  @length |= Support::HexString.from_bin(fp.read(1)).ord << shift if opcode & 0x01 > 0
                  opcode >>= 1
                  shift += 8
                end
                @length = 1 << 16 if @length == 0
              end
              
              ##
              # Applies the Hunk with a given output buffer with an input string.
              #
              # @param [IO, #write] output the output buffer we're building up
              # @param [String] input the original data. Used for copies.
              def apply(output, input)
                output.write input[@offset...@offset + @length]
              end
            end
            
          end
        end
      end
    end
  end
end
