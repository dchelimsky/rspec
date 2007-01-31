module Spec
  module Rails
    class EvalContext < Test::Unit::TestCase
      include Spec::Rails::Matchers
      cattr_accessor :fixture_path, :use_transactional_fixtures, :use_instantiated_fixtures, :global_fixtures
      remove_method :default_test if respond_to?(:default_test)
      @@model_id = 1000
      class << self
        def init_global_fixtures
          send :fixtures, self.global_fixtures if self.global_fixtures
        end
      end
      
      def add_assertion
      end

      # Creates a mock object instance for a +model_class+ with common
      # methods stubbed out.
      # Additional methods may be easily stubbed (via add_stubs) if +stubs+ is passed.
      def mock_model(model_class, stubs = {})
        id = @@model_id
        @@model_id += 1
        m = mock("#{model_class.name}_#{id}")
        m.stub!(:id).and_return(id)
        m.stub!(:to_param).and_return(id.to_s)
        m.stub!(:new_record?).and_return(false)
        m.send(:__mock_handler).instance_eval <<-CODE
          def @target.is_a?(other)
            other == #{model_class}
          end
          def @target.class
            #{model_class}
          end
        CODE
        add_stubs(m, stubs)
        yield m if block_given?
        m
      end

      # TODO - Shouldn't this just be an extension of stub! ??
      # - object.stub!(:method => return_value, :method2 => return_value2, :etc => etc)
      #
      # Stubs methods on +object+ (if +object+ is a symbol or string a new mock 
      # with that name will be created). +stubs+ is a Hash of <tt>method=>value</tt>
      def add_stubs(object, stubs = {})
        m = [String, Symbol].index(object.class) ? mock(object.to_s) : object
        stubs.each {|k,v| m.stub!(k).and_return(v)}
        m
      end
    end

    class Context < Spec::Runner::Context
    end
  end
end