# You don't need to tweak the $LOAD_PATH if you have RSpec and Spec::Ui installed as gems
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../../../rspec/lib')
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../../lib')

require 'rubygems'
require 'spec'
require 'spec/ui'
require 'spec/ui/watir'

class Spec::DSL::Behaviour
  def before_eval #:nodoc:
    include Spec::Matchers::Watir # This gives us Watir matchers
  end
end