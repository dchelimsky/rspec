module Spec
  module Rails
    class TestCase < Test::Unit::TestCase
      cattr_accessor :fixture_path, :use_transactional_fixtures, :use_instantiated_fixtures, :global_fixtures
      remove_method :default_test if respond_to?(:default_test)

      def add_assertion #:nodoc:
        # no-op
      end
    end
  end
end

module Spec
  module Rails
    module DSL
      module AllBehaviourHelpers
        ActionView::Base.cache_template_extensions = false
        class << self
          def included(mod)
            mod.send :include, ExampleMethods
            mod.send :extend, BehaviourMethods
          end
        end
        
        module BehaviourMethods
          def configure
            self.use_transactional_fixtures = Spec::Runner.configuration.use_transactional_fixtures
            self.use_instantiated_fixtures = Spec::Runner.configuration.use_instantiated_fixtures
            self.fixture_path = Spec::Runner.configuration.fixture_path
            self.global_fixtures = Spec::Runner.configuration.global_fixtures
            fixtures global_fixtures if global_fixtures
          end
        end
        
        module ExampleMethods
          @@model_id = 1000
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
            m.stub!(:errors).and_return(stub("errors", :count => 0))
            m.send(:__mock_proxy).instance_eval <<-CODE
              def @target.is_a?(other)
                #{model_class}.ancestors.include?(other)
              end
              def @target.kind_of?(other)
                #{model_class}.ancestors.include?(other)
              end
              def @target.instance_of?(other)
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

          #--
          # TODO - Shouldn't this just be an extension of stub! ??
          # - object.stub!(:method => return_value, :method2 => return_value2, :etc => etc)
          #++
          # Stubs methods on +object+ (if +object+ is a symbol or string a new mock 
          # with that name will be created). +stubs+ is a Hash of <tt>method=>value</tt>
          def add_stubs(object, stubs = {}) #:nodoc:
            m = [String, Symbol].index(object.class) ? mock(object.to_s) : object
            stubs.each {|k,v| m.stub!(k).and_return(v)}
            m
          end
        end
      end

      class EvalContext < Spec::Rails::TestCase
        include Spec::Rails::Matchers
        include Spec::Rails::DSL::AllBehaviourHelpers
      end
    end
  end
end
