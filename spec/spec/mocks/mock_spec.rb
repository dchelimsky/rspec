require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Mocks
    context "Mock" do

      setup do
        @mock = Mock.new("test mock", :auto_verify => false)
      end
      
      specify "should report line number of expectation of unreceived message" do
        @mock.should_receive(:wont_happen).with("x", 3)
        #NOTE - this test is quite ticklish because it specifies that
        #the above statement appears on line 12 of this file.

        begin
          @mock.__verify
          violated
        rescue MockExpectationError => e
          e.backtrace[0].should_match(/mock_spec\.rb:12:in `__instance_exec/)
        end
    
      end
      
      specify "should pass when not receiving message specified as not to be received" do
        @mock.should_not_receive(:not_expected)
        @mock.__verify
      end

      specify "should pass when receiving message specified as not to be received with different args" do
        @mock.should_not_receive(:message).with("unwanted text")
        @mock.should_receive(:message).with("other text")
        @mock.message "other text"
        @mock.__verify
      end

      specify "should fail when receiving message specified as not to be received" do
        @mock.should_not_receive(:not_expected)
        @mock.not_expected
        begin
          @mock.__verify
          violated
        rescue MockExpectationError => e
          e.message.should_equal "Mock 'test mock' expected :not_expected 0 times, but received it 1 times"
        end
      end

      specify "should fail when receiving message specified as not to be received with args" do
        @mock.should_not_receive(:not_expected).with("unexpected text")
        @mock.not_expected "unexpected text"
        begin
          @mock.__verify
          violated
        rescue MockExpectationError => e
          e.message.should_equal "Mock 'test mock' expected :not_expected with ['unexpected text'] 0 times, but received it 1 times"
        end
      end

      specify "should allow block to calculate return values" do
        @mock.should_receive(:random_call).with("a","b","c").and_return { |a,b,c| c+b+a }
        @mock.random_call("a","b","c").should_equal "cba"
        @mock.__verify
      end

      specify "should allow parameter as return value" do
        @mock.should_receive(:random_call).with("a","b","c").and_return("booh")
        @mock.random_call("a","b","c").should_equal "booh"
        @mock.__verify
      end

      specify "should return nil if no return value set" do
        @mock.should_receive(:random_call).with("a","b","c")
        @mock.random_call("a","b","c").should_be nil
        @mock.__verify
      end

      specify "should raise exception if parameters dont match when method called" do
        @mock.should_receive(:random_call).with("a","b","c").and_return("booh")
        begin
          @mock.random_call("a","d","c")
          violated
        rescue MockExpectationError => e
          e.message.should_equal "Mock 'test mock' received unexpected message :random_call with ['a', 'd', 'c']"
        end
      end
     
      specify "should fail if unexpected method called" do
        begin
          @mock.random_call("a","b","c")
          violated
        rescue MockExpectationError => e
          e.message.should_equal "Mock 'test mock' received unexpected message :random_call with ['a', 'b', 'c']"
        end
      end
  
      specify "should use block for expectation if provided" do
        @mock.should_receive(:random_call) do | a, b |
          a.should_equal "a"
          b.should_equal "b"
          "booh"
        end
        @mock.random_call("a", "b").should_equal "booh"
        @mock.__verify
      end
  
      specify "should fail if expectation block fails" do
        @mock.should_receive(:random_call) {| bool | bool.should_be true}
        begin
          @mock.random_call false
        rescue MockExpectationError => e
          e.message.should_equal "Mock 'test mock' received :random_call but passed block failed with: false should be true"
        end
      end
  
      specify "should fail when method defined as never is received" do
        @mock.should_receive(:not_expected).never
        begin
          @mock.not_expected
        rescue MockExpectationError => e
          e.message.should_equal "Mock 'test mock' expected :not_expected 0 times, but received it 1 times"
        end
      end
      
      specify "should raise when told to" do
        @mock.should_receive(:random_call).and_raise(RuntimeError)
        lambda do
          @mock.random_call
        end.should_raise(RuntimeError)
      end
 
      specify "should not raise when told to if args dont match" do
        @mock.should_receive(:random_call).with(2).and_raise(RuntimeError)
        lambda do
          @mock.random_call 1
        end.should_raise(MockExpectationError)
      end
 
      specify "should throw when told to" do
        @mock.should_receive(:random_call).and_throw(:blech)
        lambda do
          @mock.random_call
        end.should_throw(:blech)
      end

      specify "should raise when explicit return and block constrained" do
        lambda do
          @mock.should_receive(:fruit) do |colour|
            :strawberry
          end.and_return :apple
        end.should_raise(AmbiguousReturnError)
      end
      
      specify "should ignore args on any args" do
        @mock.should_receive(:random_call).at_least(:once).with(:any_args)
        @mock.random_call
        @mock.random_call 1
        @mock.random_call "a", 2
        @mock.random_call [], {}, "joe", 7
        @mock.__verify
      end
      
      specify "should fail on no args if any args received" do
        @mock.should_receive(:random_call).with(:no_args)
        begin
          @mock.random_call 1
        rescue MockExpectationError => e
          e.message.should_equal "Mock 'test mock' received unexpected message :random_call with [1]"
        end
      end
      
      specify "should yield single value" do
        @mock.should_receive(:yield_back).with(:no_args).once.and_yield(99)
        a = nil
        @mock.yield_back {|a|}
        a.should_equal 99
        @mock.__verify
      end

      specify "should yield two values" do
        @mock.should_receive(:yield_back).with(:no_args).once.and_yield('wha', 'zup')
        a, b = nil
        @mock.yield_back {|a,b|}
        a.should_equal 'wha'
        b.should_equal 'zup'
        @mock.__verify
      end

      specify "should fail when calling yielding method with wrong arity" do
        @mock.should_receive(:yield_back).with(:no_args).once.and_yield('wha', 'zup')
          begin
          @mock.yield_back {|a|}
        rescue MockExpectationError => e
          e.message.should_equal "Mock 'test mock' yielded |'wha', 'zup'| to block with arity of 1"
        end
      end

      specify "should fail when calling yielding method without block" do
        @mock.should_receive(:yield_back).with(:no_args).once.and_yield('wha', 'zup')
        begin
          @mock.yield_back
        rescue MockExpectationError => e
          e.message.should_equal "Mock 'test mock' asked to yield |'wha', 'zup'| but no block was passed"
        end
      end
      
      specify "should be able to mock send" do
        @mock.should_receive(:send).with(:any_args)
        @mock.send 'hi'
        @mock.__verify
      end
      
      specify "should be able to raise from method calling yielding mock" do
        @mock.should_receive(:yield_me).and_yield 44
        
        lambda do
          @mock.yield_me do |x|
            raise "Bang"
          end
        end.should_raise(StandardError)

        @mock.__verify
      end

      specify "should use a list of return values for successive calls" do
        @mock.should_receive(:multi_call).twice.with(:no_args).and_return([8, 12])
        @mock.multi_call.should_equal 8
        @mock.multi_call.should_equal 12
        @mock.__verify
      end

      specify "should clear expectations after verify" do
        @mock.should_receive(:foobar)
        @mock.foobar
        @mock.__verify
        begin
          @mock.foobar
        rescue MockExpectationError => e
          e.message.should_equal "Mock 'test mock' received unexpected message :foobar"
        end
      end
      
      specify "should verify if auto verify is set to true" do
        reporter = Spec::Mocks::Mock.new("reporter", :null_object => true)
        reporter.should_receive(:spec_finished) do |name, error, location|
          error.to_s.should_match /expected :abcde once, but received it 0 times/
        end
        Runner::Specification.new("spec") do
          mock = Spec::Mocks::Mock.new("mock", :auto_verify => true)
          mock.should_receive(:abcde)
        end.run reporter
        reporter.__verify
      end

      specify "should verify if auto verify not set explicitly" do
        reporter = Spec::Mocks::Mock.new("reporter", :null_object => true)
        reporter.should_receive(:spec_finished) do |name, error, location|
          error.to_s.should_match /expected :abcde once, but received it 0 times/
        end
        Runner::Specification.new("spec") do
          mock = Spec::Mocks::Mock.new("mock")
          mock.should_receive(:abcde)
        end.run reporter
        reporter.__verify
      end

      specify "should not verify if auto verify is set to false" do
        reporter = Spec::Mocks::Mock.new("reporter", :null_object => true)
        reporter.should_receive(:spec_finished) do |name, error, location|
          error.should_be_nil
        end
        Runner::Specification.new("spec") do
          mock = Spec::Mocks::Mock.new("mock", :auto_verify => false)
          mock.should_receive(:abcde)
        end.run reporter
        reporter.__verify
      end
    end
  end
end