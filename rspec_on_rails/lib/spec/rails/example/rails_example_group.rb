require 'spec/interop/test'


ActionView::Base.cache_template_extensions = false

module Spec
  module Rails

    class IllegalDataAccessException < StandardError; end

    module Example
      class RailsExampleGroup < Test::Unit::TestCase
        # Rails >= r8570 uses setup/teardown_fixtures explicitly
        before(:each) do
          setup_fixtures if self.respond_to?(:setup_fixtures)
        end
        after(:each) do
          teardown_fixtures if self.respond_to?(:teardown_fixtures)
        end
        
        include Spec::Rails::Matchers

        @@model_id = 1000
        # Creates a mock object instance for a +model_class+ with common
        # methods stubbed out.
        # Additional methods may be easily stubbed (via add_stubs) if +stubs+ is passed.
        def mock_model(model_class, options_and_stubs = {})
          id = @@model_id
          @@model_id += 1
          options_and_stubs = {
            :id => id,
            :to_param => id.to_s,
            :new_record? => false,
            :errors => stub("errors", :count => 0)
          }.merge(options_and_stubs)
          m = mock("#{model_class.name}_#{id}", options_and_stubs)
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
          yield m if block_given?
          m
        end
        
        # :call-seq:
        #   stub_model(Model)
        #   stub_model(Model, hash_of_stubs)
        #
        # Creates an instance of +Model+ that is prohibited from accessing the
        # database. For each key in +hash_of_stubs+, if the model has a
        # matching attribute (determined by asking it, which it answers based
        # on schema.rb) are simply assigned the submitted values. If the model
        # does not have a matching attribute, the key/value pair is assigned as
        # a stub return value using RSpec's mocking/stubbing framework.
        #
        # new_record? is overridden to return the result of id.nil? This means
        # that by default new_record? will return false. If you explicitly set
        # :id => nil, the object will behave as you would expect, and return
        # true for new_record?
        #
        # == Examples
        #
        #   stub_model(Person)
        #   stub_model(Person, :id => 37)
        #   stub_model(Person) do |person|
        #     model.first_name = "David"
        #   end
        def stub_model(model_class, stubs = {})
          id = @@model_id
          @@model_id += 1
          stubs = {
            :id => id
          }.merge(stubs)
          returning model_class.new do |model|
            model.id = stubs.delete(:id)
            (class << model; self; end).class_eval do
              def connection
                raise IllegalDataAccessException.new("stubbed models are not allowed to access the database")
              end
              def new_record?
                id.nil?
              end
              def as_new_record
                self.id = nil
                self
              end
            end
            stubs.each do |k,v|
              if model.has_attribute?(k)
                model[k] = stubs.delete(k)
              end
            end
            add_stubs(model, stubs)
            yield model if block_given?
          end
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
        Spec::Example::ExampleGroupFactory.default(self)
      end
    end
  end
end
