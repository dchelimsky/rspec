$:.push File.join(File.dirname(__FILE__), *%w[.. .. lib])
require 'spec'
require 'test/unit'

describe "spec" do
  it "should pass with should" do
    1.should == 1
  end

  it "should fail with should" do
    1.should == 2
  end
end

class NeighborlyTest < Test::Unit::TestCase
  def test_should_pass_with_assert
    assert true
  end
  
  def test_should_fail_with_assert
    assert false
  end
end