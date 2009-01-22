require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    describe ExampleMethods do
      module ModuleThatIsReopened; end

      module ExampleMethods
        include ModuleThatIsReopened
      end

      module ModuleThatIsReopened
        def module_that_is_reopened_method; end
      end

      describe "with an included module that is reopened" do
        it "should have repoened methods" do
          method(:module_that_is_reopened_method).should_not be_nil
        end
      end

      describe "eval_block" do
        before(:each) do
          @example_group = ExampleGroup.dup
        end
    
        describe "with a given description" do
          it "should provide the given description" do
            @example = @example_group.it("given description") { 2.should == 2 }
            @example.eval_block
            @example.description.should == "given description"
          end
        end

        describe "with no given description" do
          it "should provide the generated description" do
            @example = @example_group.it { 2.should == 2 }
            @example.eval_block
            @example.description.should == "should == 2"
          end
        end
    
        describe "with no implementation" do
          it "should raise an NotYetImplementedError" do
            lambda {
              @example = @example_group.it
              @example.eval_block
            }.should raise_error(Spec::Example::NotYetImplementedError, "Not Yet Implemented")
          end
      
          def extract_error(&blk)
            begin
              blk.call
            rescue Exception => e
              return e
            end
        
            nil
          end
      
          it "should use the proper file and line number for the NotYetImplementedError" do
            file = __FILE__
            line_number = __LINE__ + 3
        
            error = extract_error do
              @example = @example_group.example
              @example.eval_block
            end
        
            error.pending_caller.should =~ /#{file}:#{line_number}/
          end
        end
      end

      describe "#backtrace" do        
        it "returns the backtrace from where the example was defined" do
          example = ExampleGroup.dup.new "name"
          example.backtrace.join("\n").should include("#{__FILE__}:#{__LINE__-1}")
        end
      end
      
      describe "#implementation_backtrace (deprecated)" do
        before(:each) do
          Kernel.stub!(:warn)
        end

        it "sends a deprecation warning" do
          Kernel.should_receive(:warn).with(/#implementation_backtrace.*deprecated.*#backtrace instead/m)
          example = ExampleGroup.dup.new "name"
          example.implementation_backtrace
        end
        
        it "returns the backtrace from where the example was defined" do
          example = ExampleGroup.dup.new "name"
          example.implementation_backtrace.join("\n").should include("#{__FILE__}:#{__LINE__-1}")
        end
      end

      describe "#subject" do
        before(:each) do
          @example_group = ExampleGroupDouble
        end

        it "should return an instance of the described class" do
          group = Class.new(ExampleGroupDouble).describe(Array)
          example = group.new
          example.subject.should == []
        end
    
        it "should return nil for a module (as opposed to a class)" do
          group = Class.new(ExampleGroupDouble).describe(Enumerable)
          example = group.new
          example.subject.should be_nil
        end
    
        it "should return nil for a string" do
          group = Class.new(ExampleGroupDouble).describe('foo')
          example = group.new
          example.subject.should be_nil
        end
      end

      class Thing
        attr_reader :arg
        def initialize(arg=nil)
          @arg = arg || :default
        end
        def ==(other)
          @arg == other.arg
        end
        def eql?(other)
          @arg == other.arg
        end
      end

      describe "#should" do
        before(:each) do
          @example_group = Class.new(ExampleGroupDouble)
          @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        end
        
        context "in an ExampleGroup with an implicit subject" do
          it "delegates matcher to the implied subject" do
            @example_group.describe(Thing)
            @example_group.example { should == Thing.new(:default) }
            @example_group.example { should eql(Thing.new(:default)) }
            @example_group.run(@options).should be_true
          end
        end
        
        context "in an ExampleGroup using an explicit subject" do
          it "delegates matcher to the declared subject" do
            @example_group.describe(Thing)
            @example_group.subject { Thing.new(:other) }
            @example_group.example { should == Thing.new(:other) }
            @example_group.example { should eql(Thing.new(:other)) }
            @example_group.run(@options).should be_true
          end
        end
      end

      describe "#should_not" do
        before(:each) do
          @example_group = ExampleGroup.dup
        end

        context "in an ExampleGroup with an implicit subject" do
          it "delegates matcher to the implied subject" do
            @example_group.describe(Thing)
            @example_group.example { should_not == Thing.new(:other) }
            @example_group.example { should_not eql(Thing.new(:other)) }
            @example_group.run(::Spec::Runner::Options.new(StringIO.new, StringIO.new)).should be_true
          end
        end
        
        context "in an ExampleGroup using an explicit subject" do
          it "delegates matcher to the declared subject" do
            @example_group.describe(Thing)
            @example_group.subject { Thing.new(:other) }
            @example_group.example { should_not == Thing.new(:default) }
            @example_group.example { should_not eql(Thing.new(:default)) }
            @example_group.run(::Spec::Runner::Options.new(StringIO.new, StringIO.new)).should be_true
          end
        end
      end
    end

    describe "#options" do
      it "should expose the options hash" do
        example = ExampleGroup.dup.new "name", :this => 'that' do; end
        example.options[:this].should == 'that'
      end
    end

  end
end
