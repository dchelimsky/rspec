require File.dirname(__FILE__) + '/../../spec_helper.rb'

# module ExampleExpectations
#   class BeEmpty
#     def met_by?(target)
#       target.empty?
#     end
#   
#     def failure_message
#       "this is the message"
#     end
#   end
#   def be_empty
#     return BeEmpty.new
#   end
# end
# 
# context "Given an Expectation passed to #should" do
#   include ExampleExpectations
#   
#   specify "#should should pass the target to met_by?" do
#     a = Array.new
#     a.should be_empty
#     
#     a << 1
#     lambda { a.should be_empty }.should_fail_with "this is the message"
#   end
# end
