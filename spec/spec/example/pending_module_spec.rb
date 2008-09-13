module Spec
  module Example
    describe Pending do
      
      it 'should raise an ExamplePendingError if no block is supplied' do
        lambda {
          include Pending
          pending "TODO"
        }.should raise_error(ExamplePendingError, /TODO/)
      end
      
      it 'should raise an ExamplePendingError if a supplied block fails as expected' do
        lambda {
          include Pending
          pending "TODO" do
            raise "oops"
          end
        }.should raise_error(ExamplePendingError, /TODO/)
      end
      
      it 'should raise an ExamplePendingError if a supplied block fails as expected with a mock' do
        lambda {
          include Pending
          pending "TODO" do
            m = mock('thing')
            m.should_receive(:foo)
            m.rspec_verify
          end
        }.should raise_error(ExamplePendingError, /TODO/)
      end
      
      it 'should raise a PendingExampleFixedError if a supplied block starts working' do
        lambda {
          include Pending
          pending "TODO" do
            # success!
          end
        }.should raise_error(PendingExampleFixedError, /TODO/)
      end
    end
    
    describe PendingError do
      it "should have StandardError as it's super class" do
        PendingError.superclass.should equal(StandardError)
      end
      
      it "should have the caller (from two calls from initialization)" do
        two_calls_ago = caller[0]
        PendingError.new("a message").pending_caller.should == two_calls_ago
      end
      
      it "should keep the trace information from initialization" do
        two_calls_ago = caller[0]
        obj = PendingError.new("a message")
        obj.pending_caller
        def another_caller(obj)
          obj.pending_caller
        end
        
        another_caller(obj).should == two_calls_ago
      end
      
      it "should have the message provided" do
        PendingError.new("a message").message.should == "a message"
      end
      
      it "should use a 'PendingError' as it's default message" do
        PendingError.new.message.should == "Spec::Example::PendingError"
      end
    end
    
    describe ExamplePendingError do
      it "should have PendingError as it's super class" do
        ExamplePendingError.superclass.should equal(PendingError)
      end
      
      it "should use a 'ExamplePendingError' as it's default message" do
        ExamplePendingError.new.message.should == "Spec::Example::ExamplePendingError"
      end
    end
    
    describe PendingExampleFixedError do
      it "should have PendingError as it's super class" do
        PendingExampleFixedError.superclass.should equal(PendingError)
      end
    end
  end
end
