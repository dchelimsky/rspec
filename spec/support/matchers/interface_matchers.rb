module InterfaceMatchers
  class HaveInterfaceMatcher
    def initialize(method)
      @method = method
      @arity = 0
    end
  
    attr_reader :object
    attr_reader :method
  
    def matches?(object)
      @object = object
      object.respond_to?(@method)
    end
    
    def description
      "exposes #{@method}(#{})"
    end
  
    def with(arity)
      @arity = WithArity.new(self, @method, arity)
    end
  
    class WithArity
      def initialize(matcher, method, arity)
        @have_matcher = matcher
        @method = method
        @arity  = arity
      end
    
      def matches?(an_object)
        @have_matcher.matches?(an_object) && real_arity == @arity
      end
    
      def failure_message
        "#{@have_matcher} should have method :#{@method} with #{argument_arity}, but it had #{real_arity}"
      end
    
      def arguments
        self
      end
    
      alias_method :argument, :arguments
    
    private
    
      def real_arity
        @have_matcher.object.method(@method).arity
      end
    
      def argument_arity
        if @arity == 1
          "1 argument"
        else
          "#{@arity} arguments"
        end
      end
    end
  end

  def have_interface_for(method)
    HaveInterfaceMatcher.new(method)
  end
end