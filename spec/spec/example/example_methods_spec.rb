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

          after do
            ExampleGroup.instance_variable_set("@before_all_parts", [])
            ExampleGroup.instance_variable_set("@before_each_parts", [])
            ExampleGroup.instance_variable_set("@after_each_parts", [])
            ExampleGroup.instance_variable_set("@after_all_parts", [])
          end

          it "should pass before and after callbacks to all ExampleGroup subclasses" do
            ExampleGroup.before(:suite) do
              ExampleGroup.count.should == 1
            end

            ExampleGroup.before(:all) do
              ExampleGroup.count.should == 2
            end

            ExampleGroup.before(:each) do
              ExampleGroup.count.should == 3
            end

            ExampleGroup.after(:each) do
              ExampleGroup.count.should == 4
            end

            ExampleGroup.after(:all) do
              ExampleGroup.count.should == 5
            end

            ExampleGroup.after(:suite) do
              ExampleGroup.count.should == 6
            end

            Class.new(ExampleGroup) do
              it "should use ExampleMethods callbacks" do end
            end
            @options.run_examples
            ExampleGroup.count.should == 7
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
              
                error.pending_caller.should == "#{file}:#{line_number}"
              end
            end
          end
        end
      end

      describe "#implementation_backtrace" do
        it "returns the backtrace of where the implementation was defined" do
          example_group = Class.new(ExampleGroup) do
            it "should use ExampleMethods callbacks" do
            end
          end
          example = example_group.examples.first
          example.implementation_backtrace.join("\n").should include("#{__FILE__}:#{__LINE__-4}")
        end
      end

      describe "#__full_description" do
        it "should return the full description of the ExampleGroup and Example" do
          example_group = Class.new(ExampleGroup).describe("An ExampleGroup") do
            it "should do something" do
            end
          end
          example = example_group.examples.first
          example.__full_description.should == "An ExampleGroup should do something"
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
