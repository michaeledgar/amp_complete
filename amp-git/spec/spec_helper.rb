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
DEPENDENCIES = %w(amp-front amp-core)
DEPENDENCIES.each do |x|
  require File.join(File.dirname(__FILE__), '..', '..', x, 'lib', x)
end
require 'rubygems'
require 'amp-git'
require 'spec'
require 'spec/autorun'
require 'construct'

Spec::Runner.configure do |config|
  
end
