require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Rails
    module Example
      describe ModelExampleGroup do
        it "should clear its name from the description" do
          group = describe("foo", :type => :model) do
          end
          group.description.to_s.should == "foo"
        end
      end
    end
  end
end