require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    module Matchers
      def create(name, &block_passed_to_create)
        self.class.class_eval do
          define_method name do
            Spec::Matchers::Matcher.new &block_passed_to_create
          end
        end
      end
    end
  end
end

module Spec
  module Matchers
    class Matcher
      include InstanceExec
      def initialize(name, expected=nil, &block_passed_to_init)
        @expected = expected
        @block = block_passed_to_init
        @description = lambda { |actual|
          "expected #{actual} to be a multiple of #{expected}"
        }
      end
      def matches?(actual)
        @actual = actual
        instance_exec @expected, &@block
      end
      def match(&block_passed_to_match)
        instance_exec @actual, &block_passed_to_match
      end
      def description(&block)
        if block
          @description = block
        else
          @description.call(@actual)
        end
      end
    end
  end
end

module Spec
  module Matchers
    describe "#create" do
      context "telling #create what I want it to do" do
        it "returns true if I say so" do
          # FIXME - this expects new to be called, but we need something
          # more robust - that expects new to be called with a specific
          # block (lambda, proc, whatever)
          mod = Module.new
          mod.extend Spec::DSL::Matchers
          mod.create(:foo)
          
          Spec::Matchers::Matcher.should_receive(:new)
          
          mod.foo
        end
      end
    end
    
    describe Spec::Matchers::Matcher do
      it "provides a default description" do
        matcher = Spec::Matchers::Matcher.new(:be_a_multiple_of, 3) do |multiple|
          match do |actual|
            actual % multiple == 0
          end
        end
        matcher.matches?(9)
        matcher.description.should == "expected 9 to be a multiple of 3"
      end
      
      it "overrides the description" do
        matcher = Spec::Matchers::Matcher.new(:be_a_multiple_of, 3) do |multiple|
          match do |actual|
            actual % multiple == 0
          end
          description do |actual|
            "expected that #{actual} would be a multiple of #{multiple}"
          end
        end
        matcher.matches?(9)
        matcher.description.should == "expected that 9 would be a multiple of 3"
      end
      
      context "#new" do
        it "passes matches? arg to match block" do
          matcher = Spec::Matchers::Matcher.new(:ignore) do 
            match do |actual|
              actual == 5
            end
          end
          matcher.matches?(5).should be_true
        end

        it "exposes arg submitted through #new to matcher block" do
          matcher = Spec::Matchers::Matcher.new(:ignore, 4) do |expected|
            match do |actual|
              actual > expected
            end
          end
          matcher.matches?(5).should be_true
        end
      end
    end
  end
end
