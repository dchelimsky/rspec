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
        if description = @_proxy.description || ::Spec::Matchers.generated_description
          description
        else
          raise Spec::Example::NoDescriptionError.new("example", @_proxy.location)
        end
      end
      
      def options # :nodoc:
        @_proxy.options
      end

      def execute(run_options, instance_variables) # :nodoc:
        puts caller unless caller(0)[1] =~ /example_group_methods/
        run_options.reporter.example_started(@_proxy)
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

        run_options.reporter.example_finished(@_proxy.update(description), execution_error)
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
          unless ['@_proxy', '@_implementation', '@method_name'].include?(variable_name.to_s)
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
        Spec.deprecate("ExampleMethods#implementation_backtrace","ExampleMethods#backtrace")
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

      def initialize(example_proxy, &implementation)
        @_proxy = example_proxy
        @_implementation = implementation
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
      
    end
  end
end
