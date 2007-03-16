module Spec
  module Runner
    class BehaviourRunner
      
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
        unless paths.nil? # It's nil when running single specs with ruby
          paths = find_paths(paths)
          sorted_paths = sort_paths(paths)
          load_specs(sorted_paths) 
        end
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
      
      FILE_SORTERS = {
        'mtime' => lambda {|file_a, file_b| File.mtime(file_b) <=> File.mtime(file_a)}
      }
      
      def sorter(paths)
        sorter = FILE_SORTERS[@options.loadby]
        if sorter.nil? && @options.loadby =~ /\.txt/
          prioritised_order = File.open(@options.loadby).read.split("\n")
          verify_files(prioritised_order)
          sorter = lambda do |file_a, file_b|
            a_pos = prioritised_order.index(file_a) || paths.index(file_a) + prioritised_order.length
            b_pos = prioritised_order.index(file_b) || paths.index(file_b) + prioritised_order.length
            a_pos <=> b_pos
          end
        end
        sorter
      end
      
      def sort_paths(paths)
        sorter = sorter(paths)
        paths = paths.sort(&sorter) unless sorter.nil?
        paths
      end

    private
      
      def find_paths(paths)
        result = []
        paths.each do |path|
          if File.directory?(path)
            result += Dir["#{path}/**/*.rb"]
          elsif File.file?(path)
            result << path
          else
            raise "File or directory not found: #{file_or_dir}"
          end
        end
        result
      end
      
      def load_specs(paths)
        paths.each do |path|
          load path
        end
      end
      
      def verify_files(files)
        files.each {|file| raise "File not found: #{file}" unless File.file?(file)}
      end
      
      def spec_description
        @options.spec_name
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
