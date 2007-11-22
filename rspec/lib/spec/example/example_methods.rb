module Spec
  module Example
    module ExampleMethods
      extend ExampleGroupMethods
      extend ModuleReopeningFix

      include ::Spec::Matchers
      include ::Spec::Example::Pending
      
      attr_reader :_example
      
      def violated(message="")
        raise Spec::Expectations::ExpectationNotMetError.new(message)
      end
      
      def run
        _example.run_in(self)
      end
      
      def description
        _example.description
      end
      
      def description=(description)
        _example.description=(description)
      end
            
      def use_generated_description?
        _example.description == :__generate_docstring
      end

      def copy_instance_variables_from(obj)
        super(obj, [:@_example, :@_result])
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