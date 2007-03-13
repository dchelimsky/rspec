module Spec
  module Runner
    class ContextRunner
      
      def initialize(options)
        @contexts = []
        @options = options
      end
    
      def add_context(context)
        return unless spec_description.nil? || context.matches?(spec_description)
        context.run_single_spec(spec_description) if context.matches?(spec_description)
        @contexts << context
      end
      
      # Runs all contexts and returns the number of failures.
      def run(paths, exit_when_done)
        load_specs(paths) unless paths.nil? # It's nil when running single specs with ruby
        @options.reporter.start(number_of_specs)
        contexts = @options.reverse ? @contexts.reverse : @contexts
        begin
          contexts.each do |context|
            context.run(@options.reporter, @options.dry_run, @options.reverse)
          end
        rescue Interrupt
        ensure
          @options.reporter.end
        end
        failure_count = @options.reporter.dump
        
        heckle if(failure_count == 0 && !@options.heckle_runner.nil?)
        
        if(exit_when_done)
          exit_code = (failure_count == 0) ? 0 : 1
          exit(exit_code)
        end
        failure_count
      end
    
      def number_of_specs
        @contexts.inject(0) {|sum, context| sum + context.number_of_specs}
      end
      
      private

      def spec_description
        @options.spec_name
      end
      
      def load_specs(paths)
        paths.each do |path|
          if File.directory?(path)
            files = Dir["#{path}/**/*.rb"]
            files.sort!(&@options.file_sorter) unless @options.file_sorter.nil?
            files.each do |file| 
              load file
            end
          elsif File.file?(path)
            load path
          else
            raise "File or directory not found: #{file_or_dir}"
          end
        end
      end
      
      def heckle
        heckle_runner = @options.heckle_runner
        @options.heckle_runner = nil
        context_runner = self.class.new(@options)
        context_runner.instance_variable_set(:@contexts, @contexts)
        heckle_runner.heckle_with(context_runner)
      end
    end
  end
end
