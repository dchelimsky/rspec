$:.push File.join(File.dirname(__FILE__), *%w[.. .. lib])
require 'spec'
require 'spec/extensions/test'

class MySpec < Test::Unit::TestCase::ExampleGroup
  def should_pass_with_should
    1.should == 1
  end

  def should_fail_with_should
    1.should == 2
  end

  def should_pass_with_assert
    assert true
  end
  
  def should_fail_with_assert
    assert false
  end
end