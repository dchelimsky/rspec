require File.dirname(__FILE__) + '/simple_text_formatter'

module Spec
  class NewTextRunner
 
    def initialize(out=$stdout)
      @contexts = []
      @out = out
      @formatter = SimpleTextFormatter.new(@out)
    end
    
    def add_context(context)
      @contexts << context
      self
    end
    
    def run
      @formatter.start_time = Time.new
      @contexts.each do |context|
        context.run(@formatter)
        context.add_to_builder(@formatter)
      end
      @formatter.end_time = Time.new
      @formatter.dump
    end
    
  end
end
