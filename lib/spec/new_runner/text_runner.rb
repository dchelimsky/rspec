require File.dirname(__FILE__) + '/simple_text_report_builder'

module Spec
  class NewTextRunner
 
    def initialize(*args)
      @output = $stdout
      @verbose = true if args.include? "-v"
      @failures = Array.new
      @failure_count = 0
      @failed = false
      @contexts = []
      @specifications = []
      @builder = SimpleTextReportBuilder.new($stdout)
      at_exit { end_run }
    end
    
    def run(context)
      @builder.start_time = Time.new
      context.add_to_builder(@builder)
      context.run(self)
    end
    
    def end_run
      @builder.end_time = Time.new
      @builder.dump
    end

  end
end
