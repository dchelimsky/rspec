require 'spec_helper'
module Spec
  module Matchers
    describe "[object.should] have_received(method, *args)" do
      before do
        @object = String.new
      end

      it "does match if method is called with correct args" do
        @object.stub!(:slice)
        @object.slice(5)

        have_received(:slice, 5).matches?(@object).should be_true
      end

      it "does not match if method is called with incorrect args" do
        @object.stub!(:slice)
        @object.slice(3)

        have_received(:slice, 5).matches?(@object).should be_false
      end

      it "does not match if method is not called" do
        @object.stub!(:slice)

        have_received(:slice, 5).matches?(@object).should be_false
      end

      it "should describe itself" do
        @object.stub!(:slice)
        @object.slice(5)

        matcher = have_received(:slice, 5)
        matcher.matches?(@object)

        matcher.description.should == "to have received :slice with [5]"
      end

      it "should provide failure message for should" do
        @object.stub!(:slice)
        @object.slice(5)

        matcher = have_received(:slice, 5)
        matcher.matches?(@object)

        matcher.failure_message_for_should.should == %Q{expected "" to have received :slice with [5]}
      end

      it "should provide failure message for should not" do
        @object.stub!(:slice)
        @object.slice(5)

        matcher = have_received(:slice, 5)
        matcher.matches?(@object)

        matcher.failure_message_for_should_not.should == %Q{expected "" to not have received :slice with [5], but did}
      end
    end

  end
end
