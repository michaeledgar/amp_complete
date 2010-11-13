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

class TestGitTagObject < AmpTestCase
  
  def setup
    @content = <<-EOF
object 437b1b20df4b356c9342dac8d38849f24ef44f27
type commit
tag v1.5.0
tagger Junio C Hamano <junkio@cox.net> 1171411200 +0000

GIT 1.5.0
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF0lGqwMbZpPMRm5oRAuRiAJ9ohBLd7s2kqjkKlq1qqC57SbnmzQCdG4ui
nLE/L9aUXdWeTFPron96DLA=
=2E+0
-----END PGP SIGNATURE-----
EOF
    @tag_obj = Amp::Core::Repositories::Git::TagObject.new(
                   NodeId.sha1(@content), nil, @content)
  end
  
  def test_correct_type
    assert_equal 'tag', @tag_obj.type
  end
  
  def test_correct_content
    assert_equal @content, @tag_obj.content
  end
  
  def test_object
    assert_equal NodeId.from_hex("437b1b20df4b356c9342dac8d38849f24ef44f27"), @tag_obj.object_ref
  end
  
  def test_reffed_type
    assert_equal "commit", @tag_obj.reffed_type
  end
  
  def test_tagger
    assert_equal "Junio C Hamano <junkio@cox.net>", @tag_obj.tagger
  end
  
  def test_date
    assert_equal Time.at(1171411200), @tag_obj.date
  end
  
  def test_tag
    assert_equal "v1.5.0", @tag_obj.tag
  end
  
  def test_message
    assert_equal "GIT 1.5.0\n-----BEGIN PGP SIGNATURE-----\nVersion: GnuPG v1.4.6 (GNU/Linux)\n\n"+
                 "iD8DBQBF0lGqwMbZpPMRm5oRAuRiAJ9ohBLd7s2kqjkKlq1qqC57SbnmzQCdG4ui\nnLE/L9aUXdWeT"+
                 "FPron96DLA=\n=2E+0\n-----END PGP SIGNATURE-----", @tag_obj.message
  end
end
