$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
DEPENDENCIES = %w(amp-front amp-core)
DEPENDENCIES.each do |x|
  require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', x, 'lib', x))
end

require 'rubygems'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end
