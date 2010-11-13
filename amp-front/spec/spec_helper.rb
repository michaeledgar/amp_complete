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

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'amp-front'
require 'spec'

include Amp

Spec::Runner.configure do |config|
end

def swizzling_stdout
  new_stdout = StringIO.new
  $stdout, old_stdout = new_stdout, $stdout
  yield
  new_stdout.string
ensure
  $stdout = old_stdout
  new_stdout.string
end