require "forwardable"
require "test/unit"
require "test/unit/testresult"
Test::Unit.run = true

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
