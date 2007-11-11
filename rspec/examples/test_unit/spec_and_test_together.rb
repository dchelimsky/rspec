# To run this, stand in the same directory and say:
#
#   ruby spec_and_test_together.rb
$:.push File.join(File.dirname(__FILE__), *%w[.. .. lib])

require 'rubygems'
require 'spec'
require 'test/unit'

describe "spec" do
  it "should run alongside test" do
    5.should == 5
  end
end

class NeighborlyTest < Test::Unit::TestCase
  def test_should_run_alongside_spec
    assert_equal 5, 5
  end
end