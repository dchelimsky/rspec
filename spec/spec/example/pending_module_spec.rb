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
    end
    
    describe ExamplePendingError do
      it "should have PendingError as it's super class" do
        ExamplePendingError.superclass.should equal(PendingError)
      end
    end
    
    describe PendingExampleFixedError do
      it "should have PendingError as it's super class" do
        PendingExampleFixedError.superclass.should equal(PendingError)
      end
    end
  end
end
