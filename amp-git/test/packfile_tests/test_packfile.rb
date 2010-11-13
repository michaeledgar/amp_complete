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

class TestPackfile < AmpTestCase
  include Amp::Core::Repositories::Git
  PACK_FILE = "pack-4e1941122fd346526b0a3eee2d92f3277a0092cd.pack"
  
  def setup
    @opener = Amp::Core::Support::RootedOpener.new(File.expand_path(File.dirname(__FILE__)))
    @opener.default = :open_file # for testing purposes!
    @packfile = PackFile.new(PACK_FILE, @opener)
  end
  
  def test_load_packfile
    assert_not_nil @packfile
  end
  
  headers = [[[0b0001_1101], [1, 13]],
             [[0b1010_1001, 0b0010_1011], [2, 697]],
             [[0b1001_0000, 0b0000_0000], [1, 0]],
             [[0b1111_1111, 0b1010_1001, 0b0000_1011], [7, 23199]]]
  
  headers.each_with_index do |(input, output), idx|
    class_eval <<-EOF
      def test_header_#{idx}
        input = StringIO.new(#{input.map {|x| x.chr}.join.inspect})
        type, size = Amp::Core::Repositories::Git::PackFile::PackFileEntry.read_header(input)
        assert_equal #{output[0]}, type
        assert_equal #{output[1]}, size
      end
    EOF
  end
  
  def test_commit_lookup
    some_commit_obj = @packfile.object_for_hash(NodeId.from_hex("862a669a8ddf39a4c60be6bd40c97dc242b6128e"))
    assert_not_nil some_commit_obj
    assert_kind_of CommitObject, some_commit_obj
    assert_equal NodeId.from_hex("2ac9f8fa1628a094cced3534b63084d5f480d10a"), some_commit_obj.tree_ref
    assert_equal [NodeId.from_hex("840c43e100120cd282cf9b334b08aa5fbe2634a0")], some_commit_obj.parent_refs
    assert_equal "Michael Edgar <michael.j.edgar@dartmouth.edu>", some_commit_obj.author
    assert_equal "Michael Edgar <michael.j.edgar@dartmouth.edu>", some_commit_obj.committer
    assert_equal Time.at(1273260273), some_commit_obj.date
    assert_equal "Regenerated gemspec for version 1.1.0", some_commit_obj.message
  end
  
  # The previous test gets the first commit. no searching going on. This gets a further one.
  def test_further_lookup
    some_commit_obj = @packfile.object_for_hash(NodeId.from_hex("958cd2af1c2676e9e90c7ea45bfe384acdcf42e0"))
    assert_not_nil some_commit_obj
  end
  
  def test_tree_lookup
    some_tree_obj = @packfile.object_for_hash(NodeId.from_hex("2ac9f8fa1628a094cced3534b63084d5f480d10a"))
    assert_not_nil some_tree_obj
    entry_names = %w(.document .gitignore LICENSE README.md Rakefile VERSION lib spec yard-struct.gemspec).sort
    assert_equal entry_names, some_tree_obj.entry_names.sort
    lookedup_entry = TreeObject::TreeEntry.new("Rakefile", 0100644, NodeId.from_hex("53bbb0b38868a1bd2059a1174f54de63764013af"))
    assert_equal lookedup_entry, some_tree_obj.tree_lookup("Rakefile")
  end
  
end
