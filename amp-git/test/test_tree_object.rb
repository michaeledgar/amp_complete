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

class TestGitTreeObject < AmpTestCase
  
  def setup
    @content = "100644 example_helper.rb\x00\xD3\xD5\xED\x9DA4_"+
               "\xE3\xC3\nK\xCD<!\xEA-_\x9E\xDC=40000 examples\x00"+
               "\xAE\xCB\xE9d!|\xB9\xA6\x96\x024],U\xEE\x99\xA2\xEE\xD4\x92"
    @tree_obj = Amp::Core::Repositories::Git::TreeObject.new(
                    NodeId.sha1(@content), nil,@content)
  end
  
  def test_correct_type
    assert_equal 'tree', @tree_obj.type
  end
  
  def test_correct_content
    assert_equal @content, @tree_obj.content
  end
  
  def test_correct_num_pairs
    assert_equal 2, @tree_obj.size
  end
  
  def test_parses_filenames
    assert_not_nil @tree_obj.tree_lookup("example_helper.rb")
    assert_not_nil @tree_obj.tree_lookup("examples")
  end
  
  def test_parses_mode_correct
    assert_equal 0100644, @tree_obj.tree_lookup("example_helper.rb").mode
    assert_equal  040000, @tree_obj.tree_lookup("examples").mode
  end
  
  def test_parses_refs
    expected_first = NodeId.from_bin("\xD3\xD5\xED\x9DA4_\xE3\xC3\nK\xCD<!\xEA-_\x9E\xDC=")
    expected_second = NodeId.from_bin("\xAE\xCB\xE9d!|\xB9\xA6\x96\x024],U\xEE\x99\xA2\xEE\xD4\x92")
    assert_equal expected_first, @tree_obj.tree_lookup("example_helper.rb").ref
    assert_equal expected_second, @tree_obj.tree_lookup("examples").ref
  end
end
