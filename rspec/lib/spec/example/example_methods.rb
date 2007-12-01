module Spec
  module Example
    module ExampleMethods
      extend ExampleGroupMethods
      extend ModuleReopeningFix

      include Matchers
      include Pending
      
      attr_reader :_example

      def execute(options)
        options.reporter.example_started(_example)
        execution_error = nil

        unless options.dry_run
          Timeout.timeout(options.timeout) do
            begin
              setup_mocks_for_rspec
              before_example
              _example.run_in(self)
            rescue Exception => e
              execution_error ||= e
            end
            begin
              after_example
            rescue Exception => e
              execution_error ||= e
            end
          end
        end

        options.reporter.example_finished(_example, execution_error)
        success = execution_error.nil? || ExamplePendingError === execution_error
      end

      def before_example
        self.class.run_before_each(self)
      end

      def after_example
        self.class.run_after_each(self)
        verify_mocks_for_rspec
        Spec::Matchers.example_finished
      ensure
        teardown_mocks_for_rspec
      end
      
      def violated(message="")
        raise Spec::Expectations::ExpectationNotMetError.new(message)
      end

      def copy_instance_variables_from(obj)
        super(obj, [:@_example, :@_result])
      end

      def eval_each_fail_fast(procs) #:nodoc:
        procs.each do |proc|
          instance_eval(&proc)
        end
      end

      def eval_each_fail_slow(procs) #:nodoc:
        first_exception = nil
        procs.each do |proc|
          begin
            instance_eval(&proc)
          rescue Exception => e
            first_exception ||= e
          end
        end
        raise first_exception if first_exception
      end

    end
  end
end