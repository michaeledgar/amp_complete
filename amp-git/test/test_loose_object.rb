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

class TestGitLooseObject < AmpTestCase
  def setup
    super
    self.write_file "objects/ab/looseobject1" do |io|
      io << "blob 10\0abcdefghij"
    end
    self.write_file "objects/ab/looseobject2" do |io|
      io << "blob 4\0mikeedgarisacoolguy"
    end
    self.write_file "objects/ab/looseobject3" do |io|
      io << "blob 0\0hellogarbage"
    end
    @opener = Amp::Core::Support::RootedOpener.new(tempdir)
    @opener.default = :open_file
  end
  
  def test_simple_file
    obj = Amp::Core::Repositories::Git::LooseObject.lookup("ablooseobject1", @opener)
    assert_equal "blob", obj.type
    assert_equal "abcdefghij", obj.content
  end
  
  def test_trailing_garbage_file
    obj = Amp::Core::Repositories::Git::LooseObject.lookup("ablooseobject2", @opener)
    assert_equal "blob", obj.type
    assert_equal "mike", obj.content
  end
  
  def test_empty_file
    obj = Amp::Core::Repositories::Git::LooseObject.lookup("ablooseobject3", @opener)
    assert_equal "blob", obj.type
    assert_equal "", obj.content
  end

end
