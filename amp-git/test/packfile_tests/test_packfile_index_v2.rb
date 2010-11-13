# -*- coding: us-ascii -*-
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

require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper'))

##
# While TestPackfile has some index-related tests in it, they aren't on an
# interesting enough version 2 index file. This test suite uses an index file
# with a modest 1k entries in it, which will test its searching abilities a bit
# better.
class TestPackfileIndexV2 < AmpTestCase
  include Amp::Core::Repositories::Git
  BIG_INDEX_FILE = "pack-d23ff2538f970371144ae7182c28730b11eb37c1.idx"
  
  def setup
    @opener = Amp::Core::Support::RootedOpener.new(File.expand_path(File.dirname(__FILE__)))
    @opener.default = :open_file # for testing purposes!
    fp = @opener.open(BIG_INDEX_FILE)
    @index = PackFileIndex.parse(fp)
  end
  
  def test_load_packfile
    assert_not_nil @index
    assert_kind_of PackFileIndexV2, @index
  end
  
  def test_packfile_size
    assert_equal 0x0402, @index.size
  end
  
  def test_fanout_values
    assert_equal 0x04, @index.fanout[0]
    assert_equal 0x12, @index.fanout[3]
    assert_equal 0x62, @index.fanout[20]
  end
  
  def test_search_range_for_hash
    ranges = [0x0...0x04, 0x04...0x05, 0x05...0x0b, 0x0b...0x12, 0x12...0x18, 0x18...0x20, 0x20...0x21, 
              0x21...0x26, 0x26...0x26, 0x26...0x2c]
    ranges.each_with_index do |range, idx|
      assert_equal range, @index.search_range_for_hash("#{idx.chr}01234567890123456789")
    end    
  end
  
  ##
  # This tests normal offsets. Not big ones.
  def test_small_offset_for_index
    expected = [0x001ac4c3, 0x001bcaab, 0x001a82fe, 0x0003518e]
    0.upto(3) do |idx|
      assert_equal expected[idx], @index.offset_for_index(idx)
    end
  end
  
  ##
  # There are some hacked in long-style offsets in this index file. The
  # index file is valid, but I doubt there is a valid packfile it could
  # reference.
  #
  # All counting below is 0-indexed.
  # Offset number 8 refers to 64-bit offset #1. This long-offset is 0x0000bbbb00000000.
  # Offset number 9 refers to 64-bit offset #0. This long-offset is 0x0000ffff00000000.
  def test_big_offset_for_index
    expected = 0x0000bbbb00000000
    assert_equal expected, @index.offset_for_index(8)
    expected = 0x0000ffff00000000
    assert_equal expected, @index.offset_for_index(9)
  end
  
  def test_offset_for_hash
    pairs = [["0013A4B53EA0A0149A777E924019F80BA6588764", 0x001ac4c3],
             ["00166B16ECFFE5B872EE11824B389748A2B2C997", 0x001bcaab],
             ["004EB28B17D7FC33C7B90D2B37E79566038E29C1", 0x001a82fe],
             ["00D917561EB69F243B326DAAA13F7C09D505DB9C", 0x0003518e]]
    pairs.each do |hsh, expected|
      assert_equal expected, @index.offset_for_hash(NodeId.from_hex(hsh))
    end
  end
end
