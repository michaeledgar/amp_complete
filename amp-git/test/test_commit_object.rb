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

class TestGitCommitObject < AmpTestCase
  
  def setup
    @content = "tree ecb7b4460825bed7c0bc6d17004816d15ae32c5e\n"+
               "parent 8c27219d73786aa2e91d5ae964624ef36696c307\nauthor Michael "+
               "Edgar <michael.j.edgar@dartmouth.edu> 1273865360 -0400\ncommitter "+
               "Michael Edgar <michael.j.edgar@dartmouth.edu> 1273865360 -0400\n\n"+
               "Removed the gemspec from the repo\n"
    @commit_obj = Amp::Core::Repositories::Git::CommitObject.new(
                      Amp::Core::Repositories::Git::NodeId.sha1(@content), nil, @content)
  end
  
  def test_correct_type
    assert_equal 'commit', @commit_obj.type
  end
  
  def test_correct_content
    assert_equal @content, @commit_obj.content
  end
  
  def test_tree_ref
    assert_equal NodeId.from_hex("ecb7b4460825bed7c0bc6d17004816d15ae32c5e"), @commit_obj.tree_ref
  end
  
  def test_parent_refs
    assert_equal [NodeId.from_hex("8c27219d73786aa2e91d5ae964624ef36696c307")], @commit_obj.parent_refs
  end
  
  def test_author
    assert_equal "Michael Edgar <michael.j.edgar@dartmouth.edu>", @commit_obj.author
  end
  
  def test_committer
    assert_equal "Michael Edgar <michael.j.edgar@dartmouth.edu>", @commit_obj.author
  end
  
  def test_date
    assert_equal Time.at(1273865360), @commit_obj.date
  end
  
  def test_messages
    assert_equal "Removed the gemspec from the repo", @commit_obj.message
  end
end
