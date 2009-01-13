require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    module ModuleThatIsReopened
    end

    module ExampleMethods
      include ModuleThatIsReopened
    end

    module ModuleThatIsReopened
      def module_that_is_reopened_method
      end
    end

    describe ExampleMethods do
      describe "with an included module that is reopened" do
        it "should have repoened methods" do
          method(:module_that_is_reopened_method).should_not be_nil
        end
      end

      describe "lifecycle" do
        with_sandboxed_options do
          with_sandboxed_config do
            before do
              @options.formatters << mock("formatter", :null_object => true)
              @options.backtrace_tweaker = mock("backtrace_tweaker", :null_object => true)
              @reporter = FakeReporter.new(@options)
              @options.reporter = @reporter
            
              ExampleGroup.before_all_parts.should == []
              ExampleGroup.before_each_parts.should == []
              ExampleGroup.after_each_parts.should == []
              ExampleGroup.after_all_parts.should == []
              def ExampleGroup.count
                @count ||= 0
                @count = @count + 1
                @count
              end
            end
          end

          after do
            ExampleGroup.instance_variable_set("@before_all_parts", [])
            ExampleGroup.instance_variable_set("@before_each_parts", [])
            ExampleGroup.instance_variable_set("@after_each_parts", [])
            ExampleGroup.instance_variable_set("@after_all_parts", [])
          end

          describe "eval_block" do
            before(:each) do
              @example_group = Class.new(ExampleGroup)
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
                  @example = @example_group.it
                  @example.eval_block
                end
              
                error.pending_caller.should =~ /#{file}:#{line_number}/
              end
            end
          end
        end
      end

      describe "#backtrace" do        
        with_sandboxed_options do
          it "returns the backtrace from where the example was defined" do
            example_group = Class.new(ExampleGroup) do
              example "of something" do; end
            end
            
            example = example_group.examples.first
            example.backtrace.join("\n").should include("#{__FILE__}:#{__LINE__-4}")
          end
        end
      end
      
      describe "#implementation_backtrace (deprecated)" do
        with_sandboxed_options do
          before(:each) do
            Kernel.stub!(:warn)
          end

          it "sends a deprecation warning" do
            example_group = Class.new(ExampleGroup) {}
            example = example_group.example("") {}
            Kernel.should_receive(:warn).with(/#implementation_backtrace.*deprecated.*#backtrace instead/m)
            example.implementation_backtrace
          end
          
          it "returns the backtrace from where the example was defined" do
            example_group = Class.new(ExampleGroup) do
              example "of something" do; end
            end
            
            example = example_group.examples.first
            example.backtrace.join("\n").should include("#{__FILE__}:#{__LINE__-4}")
          end
        end
      end

      describe "#full_description" do
        it "should return the full description of the ExampleGroup and Example" do
          example_group = Class.new(ExampleGroup).describe("An ExampleGroup") do
            it "should do something" do
            end
          end
          example = example_group.examples.first
          example.full_description.should == "An ExampleGroup should do something"
        end
      end
      
      describe "#subject" do
        with_sandboxed_options do
          it "should return an instance of the described class" do
            example_group = Class.new(ExampleGroup).describe(Array) do
              example {}
            end
            example = example_group.examples.first
            example.subject.should == []
          end
      
          it "should return nil for a module (as opposed to a class)" do
            example_group = Class.new(ExampleGroup).describe(Enumerable) do
              example {}
            end
            example_group.examples.first.subject.should be_nil
          end
      
          it "should return nil for a string" do
            example_group = Class.new(ExampleGroup).describe('foo') do
              example {}
            end
            example_group.examples.first.subject.should be_nil
          end
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
        with_sandboxed_options do
          
          context "in an ExampleGroup with an implicit subject" do
            it "delegates matcher to the implied subject" do
              example_group = Class.new(ExampleGroup) do
                describe(Thing)
                example { should == Thing.new(:default) }
                example { should eql(Thing.new(:default)) }
              end
              example_group.run(options).should be_true
            end
          end
          
          context "in an ExampleGroup using an explicit subject" do
            it "delegates matcher to the declared subject" do
              example_group = Class.new(ExampleGroup) do
                describe(Thing)
                subject { Thing.new(:other) }
                example { should == Thing.new(:other) }
                example { should eql(Thing.new(:other)) }
              end
              example_group.run(options).should be_true
            end
          end
          
          after(:each) do
            ExampleGroup.reset
          end
          
        end
      end

      describe "#should_not" do
        with_sandboxed_options do

          context "in an ExampleGroup with an implicit subject" do
            it "delegates matcher to the implied subject" do
              example_group = Class.new(ExampleGroup) do
                describe(Thing)
                example { should_not == Thing.new(:other) }
                example { should_not eql(Thing.new(:other)) }
              end
              example_group.run(options).should be_true
            end
          end
          
          context "in an ExampleGroup using an explicit subject" do
            it "delegates matcher to the declared subject" do
              example_group = Class.new(ExampleGroup) do
                describe(Thing)
                subject { Thing.new(:other) }
                example { should_not == Thing.new(:default) }
                example { should_not eql(Thing.new(:default)) }
              end
              example_group.run(options).should be_true
            end
          end

          after do
            ExampleGroup.reset
          end

        end
      end
    end

    describe "#options" do
      it "should expose the options hash" do
        example_group = Class.new(ExampleGroup)
        example = example_group.example "name", :this => 'that' do; end
        example.options[:this].should == 'that'
      end
    end

  end
end
