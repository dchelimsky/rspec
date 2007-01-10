require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Matchers
  class BeEmpty
    def pass?(target)
      target.empty?
    end
  
    def message
      "this is the message"
    end
  end
  def be_empty
    return BeEmpty.new
  end
end

context "ShouldMatcher behaviour" do
  include Matchers
  
  specify "should be passed to Should, which then verifies passing it target" do
    a = Array.new
    a.should be_empty
    
    a << 1
    lambda { a.should be_empty }.should_fail_with "this is the message"
  end
end
