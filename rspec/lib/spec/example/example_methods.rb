module Spec
  module Example
    module ExampleMethods
      extend ExampleGroupMethods
      extend ModuleReopeningFix

      def execute(options)
        options.reporter.example_started(_example)
        
        execution_error = nil
        Timeout.timeout(options.timeout) do
          begin
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

        options.reporter.example_finished(_example, execution_error)
        success = execution_error.nil? || ExamplePendingError === execution_error
      end

      def instance_variable_hash
        instance_variables.inject({}) do |variable_hash, variable_name|
          variable_hash[variable_name] = instance_variable_get(variable_name)
          variable_hash
        end
      end

      def violated(message="")
        raise Spec::Expectations::ExpectationNotMetError.new(message)
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

      protected
      include Matchers
      include Pending
      attr_reader :_example
      
      def before_example
        setup_mocks_for_rspec
        self.class.run_before_each(self)
      end

      def after_example
        self.class.run_after_each(self)
        verify_mocks_for_rspec
      ensure
        teardown_mocks_for_rspec
      end

      def set_instance_variables_from_hash(instance_variables)
        instance_variables.each do |variable_name, value|
          instance_variable_set variable_name, value
        end
      end
    end
  end
end