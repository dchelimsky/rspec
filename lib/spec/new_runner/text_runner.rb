require File.dirname(__FILE__) + '/simple_text_formatter'

module Spec
  class NewTextRunner
 
    def initialize(*args)
      @contexts = []
      @out = $stdout
      @builder = SimpleTextFormatter.new(@out)
    end
    
    def add_context(context)
      @contexts << context
      self
    end
    
    def run
      @builder.start_time = Time.new
      @contexts.each do |context|
        context.run(@builder)
        context.add_to_builder(@builder)
      end
      @builder.end_time = Time.new
      @builder.dump
    end
    
  end
end
