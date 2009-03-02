module Spec
  module Example
    module ExampleMethods
      
      extend  Spec::Example::ModuleReopeningFix
      include Spec::Example::Subject::ExampleMethods
      
      def violated(message="")
        raise Spec::Expectations::ExpectationNotMetError.new(message)
      end

      # Declared description for this example:
      #
      #   describe Account do
      #     it "should start with a balance of 0" do
      #     ...
      #
      #   description
      #   => "should start with a balance of 0"
      def description
        @_defined_description || ::Spec::Matchers.generated_description || "NO NAME"
      end
      
      def options # :nodoc:
        @_options
      end

      def execute(run_options, instance_variables) # :nodoc:
        # FIXME - there is no reason to have example_started pass a name
        # - in fact, it would introduce bugs in cases where no docstring
        # is passed to it()
        run_options.reporter.example_started("")
        set_instance_variables_from_hash(instance_variables)
        
        execution_error = nil
        Timeout.timeout(run_options.timeout) do
          begin
            before_each_example
            instance_eval(&@_implementation)
          rescue Exception => e
            execution_error ||= e
          end
          begin
            after_each_example
          rescue Exception => e
            execution_error ||= e
          end
        end

        run_options.reporter.example_finished(ExampleDescription.new(description, options), execution_error)
        success = execution_error.nil? || ExamplePendingError === execution_error
      end

      def eval_each_fail_fast(blocks) # :nodoc:
        blocks.each {|block| instance_eval(&block)}
      end

      def eval_each_fail_slow(blocks) # :nodoc:
        first_exception = nil
        blocks.each do |block|
          begin
            instance_eval(&block)
          rescue Exception => e
            first_exception ||= e
          end
        end
        raise first_exception if first_exception
      end

      def instance_variable_hash # :nodoc:
        instance_variables.inject({}) do |variable_hash, variable_name|
          variable_hash[variable_name] = instance_variable_get(variable_name)
          variable_hash
        end
      end

      def set_instance_variables_from_hash(ivars) # :nodoc:
        ivars.each do |variable_name, value|
          # Ruby 1.9 requires variable.to_s on the next line
          unless ['@_defined_description', '@_options', '@_implementation', '@method_name'].include?(variable_name.to_s)
            instance_variable_set variable_name, value
          end
        end
      end

      # Provides the backtrace up to where this example was declared.
      def backtrace
        @_backtrace
      end
      
      # Deprecated - use +backtrace()+
      def implementation_backtrace
        Kernel.warn <<-WARNING
ExampleMethods#implementation_backtrace is deprecated and will be removed
from a future version. Please use ExampleMethods#backtrace instead.
WARNING
        backtrace
      end
      
      # Run all the before(:each) blocks for this example
      def run_before_each
        example_group_hierarchy.run_before_each(self)
      end

      # Run all the after(:each) blocks for this example
      def run_after_each
        example_group_hierarchy.run_after_each(self)
      end

      def initialize(description, options={}, &implementation)
        @_options = options
        @_defined_description = description
        @_implementation = implementation || pending_implementation
        @_backtrace = caller
      end

    private
    
      include Matchers
      include Pending
      
      def before_each_example # :nodoc:
        setup_mocks_for_rspec
        run_before_each
      end

      def after_each_example # :nodoc:
        run_after_each
        verify_mocks_for_rspec
      ensure
        teardown_mocks_for_rspec
      end

      def described_class # :nodoc:
        self.class.described_class
      end
      
      def description_args
        self.class.description_args
      end

      def example_group_hierarchy
        self.class.example_group_hierarchy
      end
      
      def pending_implementation
        error = Spec::Example::NotYetImplementedError.new(caller)
        lambda { raise(error) }
      end

    end
  end
end
