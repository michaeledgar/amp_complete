module Amp
  module Core
  end
  module Support
  end
end

class Amp::Plugins::Git < Amp::Plugins::Base
  def initialize(opts={})
    @opts = opts
  end
  
  def load!
    require 'amp-git'
  end
end
