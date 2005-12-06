require 'spec'

module Spec
  # TODO: Could we try to make this a mixin (Module) instead? It would make it easier to
  # create extensions that can be mixed and matched (AH).
  class Context
  
    def initialize(specification=nil)
      @specification = specification
      @mocks = []
    end

    def setup
    end

    def teardown
    end
    
    # Creates a new named mock that will be automatically verified after #teardown
    # has run. By using this method instead of Mock#new you don't have to worry about
    # forgetting to verify your mocks.
    def mock(name)
      mock = Mock.new(name)
      @mocks << mock
      mock
    end

    # Immediately violates the current specification with +message+.
    def violated(message="")
      raise Spec::Exceptions::ExpectationNotMetError.new(message)
    end

    def self.collection
      specs = []
      self.specifications.each do |spec|
        specs << self.new(spec.to_sym)
      end

      return specs
    end

    def run(result_listener)
      result = false

      result_listener.spec(@specification)
      setup
      begin
        __send__(@specification)
        result_listener.pass(@specification)
      rescue Exception
        result_listener.failure(@specification, $!)
      ensure
        begin
          teardown
          verify_mocks
        rescue Exception
          result_listener.failure(@specification, $!)
        end
      end

      return result
    end

    def self.add_specification(name, &block)
      self.send(:define_method, name.to_sym, Proc.new { || block.call })
    end

  private
  
    def self.my_methods
      self.instance_methods - self.superclass.instance_methods
    end

    def self.specification_name?(name)
      return false unless self.new.method(name).arity == 0
      return false if name[0..0] == '_'
      true
    end

    def self.specifications
      return self.my_methods.select {|spec| self.specification_name?(spec)}
    end

    def verify_mocks
      @mocks.each{|m| m.__verify}
    end

  end
end
