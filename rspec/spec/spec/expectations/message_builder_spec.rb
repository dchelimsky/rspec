require File.dirname(__FILE__) + '/../../spec_helper.rb'

# The very first RSpec spec that was written because of Heckle's feedback
#
# bin/spec spec/spec/expectations/message_builder_spec.rb -H Spec::Expectations::MessageBuilder
#
# If you comment out the should, heckle will complain
context "MessageBuilder" do
  specify "should quote" do
    b = Spec::Expectations::MessageBuilder.new
    b.build_message("one", "two", "three").should == '"one" two "three"'
  end
end