module Spec
  module Rails
    module DSL
      class RailsExampleSpace < ::Spec::DSL::ExampleSpace
        include Spec::Rails::Matchers
        
        def initialize(behaviour, example) #:nodoc:
          super
          @test_case = test_case_class.new
          def self.method_missing(method_name, *args, &block)
            return ::Spec::Matchers::Be.new(method_name, *args) if method_name.starts_with?("be_")
            return ::Spec::Matchers::Has.new(method_name, *args) if method_name.starts_with?("have_")
            return @test_case.send(method_name, *args, &block) if @test_case.respond_to?(method_name)
            super
          end
        end

        def_delegators  :@rspec_behaviour,
                        :test_case_class

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
  end
end
