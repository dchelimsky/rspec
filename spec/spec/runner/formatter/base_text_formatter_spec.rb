require File.dirname(__FILE__) + '/../../../spec_helper'
require 'spec/runner/formatter/base_text_formatter'

module Spec
  module Runner
    module Formatter
      describe BaseTextFormatter do
        
        before :all do
          @sandbox = "spec/sandbox"
        end

        it "should create the directory contained in WHERE if it does not exist" do
          FileUtils.should_receive(:mkdir_p).with(@sandbox)
          File.stub!(:open)
          BaseTextFormatter.new({},"#{@sandbox}/temp.rb")
        end
        
        context "(deprecations)" do
          before(:each) do
            Kernel.stub!(:warn)
            @io = StringIO.new
            @options = mock('options')
            @options.stub!(:dry_run).and_return(false)
            @options.stub!(:colour).and_return(false)
            @formatter = Class.new(BaseTextFormatter) do
              def method_that_class_magenta(message)
                magenta(message)
              end
              def method_that_class_colourise(message, failure)
                colourise(message, failure)
              end
            end.new(@options, @io)
            @failure = stub('failure', :pending_fixed? => false)
          end
          
          context "#colourise" do
            it "warns when subclasses call colourise" do
              Kernel.should_receive(:warn).with(/DEPRECATED/)
              @formatter.method_that_class_colourise('this message', @failure)
            end
            
            it "delegates to colorize_failure" do
              @formatter.should_receive(:colorize_failure).with('this message', @failure)
              @formatter.colourise('this message', @failure)
            end
          end
          
          context "#magenta" do
            it "warns when subclasses call magenta" do
              Kernel.should_receive(:warn).with(/DEPRECATED/)
              @formatter.method_that_class_magenta('this message')
            end

            it "delegates to red" do
              @formatter.should_receive(:red).with('this message')
              @formatter.method_that_class_magenta('this message')
            end
          end
          
        end
        
      end
    end
  end
end
