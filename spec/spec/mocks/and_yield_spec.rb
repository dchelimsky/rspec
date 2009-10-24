require 'spec_helper'

module Spec
  module Mocks
    describe Mock do
      describe "#and_yield" do
        context "with eval context as block argument" do
          let(:obj) { double }
          
          it "evaluates a supplied block as it is read" do
            evaluated = false
            obj.stub(:method_that_accepts_a_block).and_yield do |eval_context|
              evaluated = true
            end
            evaluated.should be_true
          end

          it "passes an eval context object to the supplied block" do
            obj.stub(:method_that_accepts_a_block).and_yield do |eval_context|
              eval_context.should_not be_nil
            end
          end

          it "evaluates the block passed to the stubbed method in the context of the supplied eval context" do
            eval_context_provided_by_and_yield = nil
            eval_context_yielded_to_when_stub_invoked = nil

            obj.stub(:method_that_accepts_a_block).and_yield do |eval_context|
              eval_context_provided_by_and_yield = eval_context
            end

            obj.method_that_accepts_a_block do
              eval_context_yielded_to_when_stub_invoked = self
            end
            
            eval_context_yielded_to_when_stub_invoked.should equal(eval_context_provided_by_and_yield)
          end
          
          it "passes when expectations set on the eval context are met" do
            configured_eval_context = nil
            obj.stub(:method_that_accepts_a_block).and_yield do |eval_context|
              configured_eval_context = eval_context
              configured_eval_context.should_receive(:foo)
            end

            obj.method_that_accepts_a_block do
              foo
            end
            
            configured_eval_context.rspec_verify
          end

          it "fails when expectations set on the eval context are not met" do
            configured_eval_context = nil
            obj.stub(:method_that_accepts_a_block).and_yield do |eval_context|
              configured_eval_context = eval_context
              configured_eval_context.should_receive(:foo)
            end

            obj.method_that_accepts_a_block do
              # foo is not called here
            end
            
            lambda {configured_eval_context.rspec_verify}.should raise_error(MockExpectationError)
          end

        end
      end
    end
  end
end

