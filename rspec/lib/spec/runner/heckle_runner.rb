require 'rubygems'
require 'heckle'

module Spec
  module Runner
    # Creates a new Heckler configured to heckle all methods in the classes
    # whose name matches +filter+
    class HeckleRunner
      def initialize(filter, heckle_class=Heckler)
        @filter = /^#{filter}/
        @heckle_class = heckle_class
      end
      
      # Runs all the contexts held by +context_runner+ once for each of the 
      # methods in the matched classes.
      def heckle_with(context_runner)
        classes = []
        ObjectSpace.each_object(Class) do |klass|
          classes << klass if klass.name =~ @filter
        end
        
        classes.each do |klass|
          klass.instance_methods(false).each do |method|
            heckle = @heckle_class.new(klass.name, method, context_runner)
            heckle.validate
          end
        end
      end
    end
    
    class Heckler < Heckle
      def initialize(klass_name, method_name, context_runner)
        super(klass_name, method_name)
        @context_runner = context_runner
      end

      def tests_pass?
        failure_count = @context_runner.run(false)
        failure_count == 0
      end
    end
  end
end