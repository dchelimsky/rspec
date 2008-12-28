require File.dirname(__FILE__) + "/../../../spec_helper"

module Spec
  module Runner
    module Formatter
      describe BaseFormatter do
        include InterfaceMatchers

        before :each do
          @options, @where = nil, nil
          @formatter = BaseFormatter.new(@options, @where)
        end
        
        it "responds to #start with one arg"do
          @formatter.should have_interface_for(:start).with(1).argument
        end
        
        it "responds to #add_example_group with one arg"do
          @formatter.should have_interface_for(:add_example_group).with(1).argument
        end
        
        it "responds to #example_started with one arg"do
          @formatter.should have_interface_for(:example_started).with(1).argument
        end
        
        it "responds to #example_failed with three args"do
          @formatter.should have_interface_for(:example_failed).with(3).arguments
        end
        
        it "responds to #example_pending with three arguments" do
          @formatter.should have_interface_for(:example_pending).with(3).arguments
        end
        
        it "responds to #start_dump with zero arguments" do
          @formatter.should have_interface_for(:start_dump).with(0).arguments
        end
        
        it "responds to #dump_failure with two arguments" do
          @formatter.should have_interface_for(:dump_failure).with(2).arguments
        end
        
        it "responds to #dump_summary with two arguments" do
          @formatter.should have_interface_for(:dump_failure).with(2).arguments
        end

        it "responds to #dump_pending with zero arguments" do
          @formatter.should have_interface_for(:dump_pending).with(0).arguments
        end

        it "responds to #close with zero arguments" do
          @formatter.should have_interface_for(:close).with(0).arguments
        end
      end
    end
  end
end
