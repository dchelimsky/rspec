require "forwardable"

require 'spec/extensions'
require 'spec/version'
require 'spec/matchers'
require 'spec/expectations'
require 'spec/translator'
require 'spec/dsl'
require 'spec/runner'
require 'spec/story'

class Object
  def metaclass
    class << self; self; end
  end
end
