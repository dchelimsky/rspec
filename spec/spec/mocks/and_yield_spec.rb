require 'spec_helper'

module Spec
  module Mocks
    describe Mock do
      describe "#and_yield" do

        let(:m) { mock }

        it "evaluates the yielded block in the context of the implicit receiver" do
          m.stub(:message_that_yields).and_yield do |implicit_receiver|
            implicit_receiver.should_receive(:foo)
          end
          m.message_that_yields do
            foo
          end
        end
        
        it "evaluates the yielded block in the context of the implicit receiver" do
          m.should_receive(:message_that_yields).and_yield do |implicit_receiver|
            implicit_receiver.should_not_receive(:foo)
          end
          expect do
            m.message_that_yields do
              foo
            end
          end.to raise_error(MockExpectationError)
        end

      end
    end
  end
end