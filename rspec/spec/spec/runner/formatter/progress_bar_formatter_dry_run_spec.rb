require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
  module Runner
    module Formatter
      describe ProgressBarFormatter, "dry run" do
        before(:each) do
          @io = StringIO.new
          @options = Options.new(StringIO.new, @io)
          @formatter = @options.create_formatter(ProgressBarFormatter)
          @options.dry_run = true
        end
      
        it "should not produce summary on dry run" do
          @formatter.dump_summary(3, 2, 1, 0)
          @io.string.should eql("")
        end
      end
    end
  end
end
