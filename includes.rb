class ExampleGroup
  class << self
    def examples
      @examples ||= []
    end
  
    def example(&block)
      examples << block
    end
  
    def run
      examples.each do |example|
        new.instance_eval &example
      end
    end
    
    def describe(scope=nil, &block)
      k = Class.new(self)
      k.include_scope(scope) if scope
      k.module_eval(&block)
      $klasses << k
    end
    
    alias :context :describe
    
    def include_scope(scope)
      include scope
    end
  end
end

$klasses = []

def describe(&block)
  ExampleGroup.describe(self, &block)
end

module A
  module B
    class Thing
      def foo
        "FOO"
      end
    end
  end
end

module A
  module B
    describe do
      class Other
        def bar
          "BAR"
        end
      end
      example do
        thing = Thing.new
        puts thing.foo
      end
      
      describe do
        context do
          example do
            other = Other.new
            puts other.bar
          end
        end
      end
    end

  end
end

$klasses.each {|k| k.run}

