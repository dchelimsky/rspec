module Spec
  module DSL
    module ExampleGroupMethods
      include ::Spec::Matchers
      include ::Spec::DSL::Pending

      attr_reader :rspec_definition
      alias_method :definition, :rspec_definition

      def initialize(definition) #:nodoc:
        @rspec_definition = definition
        @_result = ::Test::Unit::TestResult.new
      end

      def violated(message="")
        raise Spec::Expectations::ExpectationNotMetError.new(message)
      end

      def copy_instance_variables_from(obj)
        super(obj, [:@rspec_definition, :@_result])
      end

      def run_before_all
        self.class.run_before_all(self)
      end

      def run_before_each
        self.class.run_before_each(self)
      end

      def run_after_each
        self.class.run_after_each(self)
      end

      def run_after_all
        self.class.run_after_all(self)
      end

      def run_example
        instance_eval(&rspec_definition.example_block)
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