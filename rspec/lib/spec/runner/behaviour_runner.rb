module Spec
  module Runner
    class BehaviourRunner
      FILE_SORTERS = {
        'mtime' => lambda {|file_a, file_b| File.mtime(file_b) <=> File.mtime(file_a)}
      }
      
      def initialize(options)
        @behaviours = []
        @options = options
      end
    
      def add_behaviour(behaviour)
        if behaviour.shared?
          raise ArgumentError, "Cannot add Shared Example to the BehaviourRunner"
        end
        @behaviours << behaviour
        behaviour.rspec_options = @options
      end
      
      # Runs all behaviours and returns the number of failures.
      def run(paths, exit_when_done)
        prepare(paths)
        failure_count = nil
        begin
          run_behaviours
        rescue Interrupt
        ensure
          failure_count = finish
        end
        
        heckle if(failure_count == 0 && @options.heckle_runner)
        
        if(exit_when_done)
          exit_code = (failure_count == 0) ? 0 : 1
          # TODO - get rid of exit when done and all that stuff (AH)
          exit(exit_code)
        end
        failure_count
      end

      def prepare(paths)
        return if @already_prepared
        @already_prepared = true
        unless paths.nil? # It's nil when running single specs with ruby
          paths = find_paths(paths)
          sorted_paths = sort_paths(paths)
          load_specs(sorted_paths) # This will populate @behaviours via callbacks to add_behaviour
        end
        @options.reporter.start(number_of_examples)
        @behaviours.reverse! if @options.reverse
        set_sequence_numbers
      end

      def finish
        report_end
        report_dump
      end
      
    protected

      def sorter(paths)
        FILE_SORTERS[@options.loadby]
      end

      def sort_paths(paths)
        sorter = sorter(paths)
        paths = paths.sort(&sorter) unless sorter.nil?
        paths
      end

      def number_of_examples
        @behaviours.inject(0) {|sum, behaviour| sum + behaviour.number_of_examples}
      end

      def run_behaviours
        @behaviours.each do |behaviour|
          behaviour.rspec_options = @options
          suite = behaviour.suite
          suite.run(nil)
        end
      end

      def report_end
        @options.reporter.end
      end

      def report_dump
        @options.reporter.dump
      end
      
      # Sets the #number on each ExampleDefinition
      def set_sequence_numbers
        number = 0
        @behaviours.each do |behaviour|
          number = behaviour.set_sequence_numbers(number, @options.reverse)
        end
      end
      
      def find_paths(paths)
        result = []
        paths.each do |path|
          if test ?d, path
            result += Dir[File.expand_path("#{path}/**/*.rb")]
          elsif test ?f, path
            result << path
          else
            raise "File or directory not found: #{path}"
          end
        end
        result
      end
      
      def load_specs(paths)
        paths.each do |path|
          load path
        end
      end
      
      def heckle
        heckle_runner = @options.heckle_runner
        @options.heckle_runner = nil
        behaviour_runner = self.class.new(@options)
        behaviour_runner.instance_variable_set(:@behaviours, @behaviours)
        heckle_runner.heckle_with(behaviour_runner)
      end
    end
  end
end
