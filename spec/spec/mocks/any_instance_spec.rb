require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Mocks
    module AnyInstance
      describe "any_instance.stub!" do
        before(:each) do
          @klass = Class.new do
            def original_method
              :original_method
            end
          end
        end

        it "should return nil with no arguments for the first instance" do
          @klass.any_instance.stub!(:foo)
          object = @klass.new
          object.foo.should be_nil
        end

        it "should return nil with no arguments for the second instance" do
          @klass.any_instance.stub!(:foo)
          object = @klass.new
          
          object.foo.should be_nil
          object.foo.should be_nil
        end

        it "should use a return value" do
          @klass.any_instance.stub!(:foo).and_return(:bar)
          object = @klass.new
          
          object.foo.should equal(:bar)
        end

        it "should use a StandardError when and_raise is given with no arguments" do
          @klass.any_instance.stub!(:foo).and_raise
          object = @klass.new
          
          lambda { 
            object.foo
          }.should raise_error(StandardError)
        end

        it "should use a custom error when and_raise is given with a class argument" do
          error_class = Class.new(StandardError)
          @klass.any_instance.stub!(:foo).and_raise(error_class)
          object = @klass.new
          
          lambda { 
            object.foo
          }.should raise_error(error_class)
        end

        it "should use a custom error with a custom message when and_raise is given with a class and message" do
          error_class = Class.new(StandardError)
          messsage = "foobar"
          
          @klass.any_instance.stub!(:foo).and_raise(error_class, messsage)
          object = @klass.new
          
          lambda { 
            object.foo
          }.should raise_error(error_class, messsage)
        end

        it "should raise with a string when given one" do
          error_message = "Here is my error"
          
          @klass.any_instance.stub!(:foo).and_raise(error_message)
          object = @klass.new
          
          lambda { 
            object.foo
          }.should raise_error(error_message)

        end

        it "should overwrite the value of the original method" do
          @klass.any_instance.stub!(:original_method).and_return :bar
          object = @klass.new
          
          object.original_method.should equal(:bar)
        end

        it "should raise an error if the object given is not a class" do
          instance = Object.new
          lambda { 
            instance.any_instance.stub!(:baz)
          }.should raise_error(NoMethodError, "undefined method `any_instance' for #{instance}")
        end

        describe "resetting" do
          before :each do
            @klass = Class.new do
              def method_with_one_argument(arg1)
                arg1
              end
              
              def method_with_two_arguments(arg1, arg2)
                [arg1, arg2]
              end
              
              def method_which_yields(&blk)
                blk.call
              end
              
              def method_which_yields_one_arg(&blk)
                blk.call(true)
              end
              
              def bar
                :bar_return_value
              end
            end
          end

          it "should be able to reset itself" do
            @klass.any_instance.stub!(:bar)
            @klass.__rspec_clear_instances__
            instance = @klass.new
            
            instance.bar.should equal(:bar_return_value)
          end

          it "should use one argument" do
            @klass.any_instance.stub!(:method_with_one_argument)
            @klass.__rspec_clear_instances__
            instance = @klass.new
            
            instance.method_with_one_argument(:arg1).should equal(:arg1)
          end

          it "should use two arguments" do
            @klass.any_instance.stub!(:method_with_two_arguments)
            @klass.__rspec_clear_instances__
            instance = @klass.new
            
            instance.method_with_two_arguments(:arg1, :arg2).should eql([:arg1, :arg2])
          end

          it "should yield to the block" do
            @klass.any_instance.stub!(:method_which_yields)
            @klass.__rspec_clear_instances__
            instance = @klass.new
            
            val = nil
            instance.method_which_yields do
              val = true
            end
            
            val.should be_true
          end

          it "should yield to block with one argument" do
            @klass.any_instance.stub!(:method_which_yields_one_arg)
            @klass.__rspec_clear_instances__
            instance = @klass.new
            
            val = nil
            instance.method_which_yields_one_arg do |yield_value|
              val = yield_value
            end
            
            val.should be_true
          end

          it "should not leave methods laying around" do
            lambda { 
              @klass.any_instance.stub!(:method_which_yields_one_arg)
              @klass.__rspec_clear_instances__
            }.should_not change(@klass, :instance_methods)
          end
        end

        describe "in the mock space" do
          before :each do
            klass = MethodStubber
            @stubber = mock(klass, :null_object => true)
            klass.stub!(:new).and_return @stubber
          end
          
          it "should register itself in the global mock space" do
            $rspec_mocks.should_receive(:add).with(@stubber)
            @klass.any_instance.stub!(:foo)
          end
        end
      end

      describe "conforming with the other mock types in the mock space" do
        before :each do
          @stubber_class = MethodStubber
          @stubber = @stubber_class.new(Class.new, :foo)
        end
        
        it "should not do anything when calling rspec_verify (it should not be the method inherited from Object)" do
          @stubber.rspec_verify
          @stubber.should be_verified
        end
        
        it "should not be verified if it was not verified" do
          @stubber.should_not be_verified
        end
        
        it "should not use the rspec_reset inherited from Object (reset! should be it's alias)" do
          reset_method = @stubber_class.instance_method(:reset!)
          rspec_reset = @stubber_class.instance_method(:rspec_reset)
          
          reset_method.should == rspec_reset
          rspec_reset.should == reset_method
        end
      end

      describe "any_instance, with a block given" do
        before :each do
          @klass = Class.new
        end
        
        it "should stub a method in the block (with no return value)" do
          @klass.any_instance do |instance|
            instance.stub!(:foo)
          end
          
          @klass.new.foo.should be_nil
        end
        
        it "should stub a method in the block (with a return value)" do
          @klass.any_instance do |instance|
            instance.stub!(:foo).and_return(:bar)
          end
          
          @klass.new.foo.should equal(:bar)
        end
        
        it 'should stub multiple methods in the block' do
          @klass.any_instance do |instance|
            instance.stub!(:foo).and_return(:bar)
            instance.stub!(:baz).and_return(:quxx)
          end
          
          @klass.new.foo.should equal(:bar)
          @klass.new.baz.should equal(:quxx)
        end
      end
    end
  end
end
