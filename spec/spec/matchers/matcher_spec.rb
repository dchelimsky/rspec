require File.dirname(__FILE__) + '/../../spec_helper'

# Spec::Matchers.extend Spec::DSL::Matchers

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
      def initialize(expected=nil, &block_passed_to_init)
        @expected = expected
        @block = block_passed_to_init
      end
      def matches?(actual)
        @actual = actual
        instance_exec @expected, &@block
      end
      def match(&block_passed_to_match)
        instance_exec @actual, &block_passed_to_match
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
      context "#new" do
        it "returns true when I say return true" do
          matcher = Spec::Matchers::Matcher.new do 
            match do
              true
            end
          end
          matcher.matches?(5).should be_true
        end
        it "returns false when I say return false" do
          matcher = Spec::Matchers::Matcher.new do 
            match do
              false
            end
          end
          matcher.matches?(5).should be_false
        end
        
        it "returns true when actual == expected" do
          matcher = Spec::Matchers::Matcher.new do 
            match do |actual|
              actual == 5
            end
          end
          matcher.matches?(5).should be_true
        end

        it "returns true when actual == expected" do
          matcher = Spec::Matchers::Matcher.new(4) do |expected|
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
