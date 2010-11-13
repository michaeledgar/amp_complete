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

class TestGitIndex < AmpTestCase
  include Amp::Core::Repositories::Git
  INPUT_FILE = "index"
  
  def setup
    super
    @opener = Amp::Core::Support::RootedOpener.new(File.expand_path(File.dirname(__FILE__)))
    @opener.default = :open_file # for testing purposes!
    @index = Amp::Core::Repositories::Git::Index.parse(INPUT_FILE, @opener)
  end
  
  def test_open_index
    assert_not_nil @index
  end
  
  def test_lookup_fails
    assert_nil @index["roflkopterz"]
  end
  
  def test_failed_fourcc
    self.write_file "fakeindex" do |io|
      io << "DIRT\x00\x00\x00\x02"
    end
    opener = Amp::Core::Support::RootedOpener.new(tempdir)
    opener.default = :open_file
    assert_raises Index::IndexParseError do
      Amp::Core::Repositories::Git::Index.parse("fakeindex", opener)
    end
  end
  
  def test_lookup_succeeds
    assert_not_nil @index["Rakefile"]
  end
  
  def test_info_loads
    rakefile_info = @index["Rakefile"]
    assert_equal 0x4be39e30, rakefile_info.ctime
    assert_equal 0, rakefile_info.ctime_ns
    assert_equal 0x4be39e30, rakefile_info.mtime
    assert_equal 0, rakefile_info.mtime_ns
    assert_equal 0x0e000003, rakefile_info.dev
    assert_equal 0x01d75ecc, rakefile_info.inode
    assert_equal 0x81a4, rakefile_info.mode
    assert_equal 0x01f5, rakefile_info.uid
    assert_equal 0x14, rakefile_info.gid
    assert_equal 0x05c5, rakefile_info.size
    assert_equal "53bbb0b38868a1bd2059a1174f54de63764013af", rakefile_info.hash_id.to_hex
    assert_false rakefile_info.assume_valid
    assert_false rakefile_info.update_needed
    assert_equal 0, rakefile_info.stage
    assert_equal "Rakefile", rakefile_info.name
  end
end
