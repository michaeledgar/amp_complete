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
##################################################################

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Amp::Core::Repositories::Git::NodeId do
  Subject = Amp::Core::Repositories::Git::NodeId
  it 'created from binary' do
    Subject.from_bin('A').should be
  end

  it 'created from hex' do
    Subject.from_hex('41').should be
  end

  it 'created from sha1' do
    Subject.sha1('A').should be
  end

  it 'is compareable' do
    Subject.from_bin('A').should == Subject.from_bin('A')
  end

  let :single do
    Subject.from_bin('A')
  end

  it 'can be represented as binary' do
    single.to_bin.should == 'A'
  end

  it 'can be represented as hex' do
    single.to_hex.should == '41'
  end

  it 'stringifies as hex' do
    single.to_s.should == '41'
  end
end
