module Spec
  module Runner
    class Specification
      
      @@current_spec = nil
    
      def self.add_listener listener
        @@current_spec.add_listener listener unless @@current_spec.nil?
      end
      
      def initialize(name, opts={}, &block)
        @name = name
        @options = opts
        @block = block
        @listeners = []
      end

      def run(reporter=nil, setup_block=nil, teardown_block=nil, dry_run=false, execution_context=nil)
        reporter.spec_started(@name) unless reporter.nil?
        return reporter.spec_finished(@name) if dry_run
        @@current_spec = self
        execution_context = execution_context || ::Spec::Runner::ExecutionContext.new(self)
        errors = []
        begin
          execution_context.instance_exec(&setup_block) unless setup_block.nil?
          setup_ok = true
          execution_context.instance_exec(&@block)
          spec_ok = true
        rescue => e
          errors << e
        end

        begin
          execution_context.instance_exec(&teardown_block) unless teardown_block.nil?
          teardown_ok = true
        rescue => e
          errors << e
        ensure
          notify_after_teardown errors
          @@current_spec = nil
        end
        
        ShouldRaiseMatcher.new(@options).handle(errors)

        reporter.spec_finished(@name, errors.first, failure_location(setup_ok, spec_ok, teardown_ok)) unless reporter.nil?
      end

      def matches_matcher?(matcher)
        matcher.matches? @name 
      end

      def add_listener listener
        @listeners << listener
      end

      def notify_after_teardown errors
        @listeners.each do |listener|
          begin
            listener.spec_finished(self) if listener.respond_to?(:spec_finished)
          rescue => e
            errors << e
          end
        end
      end

      private
      def failure_location(setup_ok, spec_ok, teardown_ok)
        return 'setup' unless setup_ok
        return @name unless spec_ok
        return 'teardown' unless teardown_ok
      end
    end
    
    class ShouldRaiseMatcher
      def initialize(opts)
        @options = opts
        @error_class = determine_error_class(opts)
      end
      
      def determine_error_class(opts)
        if candidate = opts[:should_raise]
          if candidate.is_a?(Class)
            return candidate
          elsif candidate.is_a?(Array)
            return candidate[0]
          else
            return Spec::Expectations::ExpectationNotMetError
          end
        end
      end

      #TODO - refactor me - PLEASE! (I work, but I'm ugly)
      # - I also don't work that well yet (not enough specs!)
      # - I need to handle expected messages (a la should_raise)
      #   and I need to provide messages in the style of Should
      def handle(errors)
        if @error_class
          if errors.empty?
            errors << Spec::Expectations::ExpectationNotMetError.new
          else
            error_to_remove = errors.detect do |error|
              error.kind_of?(@error_class)
            end
            if error_to_remove.nil?
              errors.insert(0,Spec::Expectations::ExpectationNotMetError.new)
            else
              errors.delete(error_to_remove)
            end
          end
        end
      end
    end
  end
end