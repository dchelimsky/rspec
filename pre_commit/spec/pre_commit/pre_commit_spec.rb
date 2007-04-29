require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../../lib/pre_commit/pre_commit'

##
# This is not a complete specification of PreCommit, but 
# just a collection of bug fix regression tests.
describe "The helper method PreCommit#silent_sh" do
  setup do
    @pre_commit = PreCommit.new(nil)
  end

  # bug in r1802
  it "should return the command output" do
    @pre_commit.send(:silent_sh, "echo foo").should ==("foo\n")
  end
end
