module Spec
  module Story
    class StepMother
      def initialize(step_matchers=nil)
        @steps = Hash.new do |hsh,type|
          hsh[type] = Hash.new do |hsh,name|
            if step_matchers and step_matchers.find(type, name)
            else
              SimpleStep.new(name) do
                raise Spec::DSL::ExamplePendingError.new("Unimplemented step: #{name}")
              end
            end
          end
        end
      end
      
      def store(type, name, step)
        @steps[type][name] = step
      end
      
      def find(type, name)
        @steps[type][name]
      end
      
      def clear
        @steps.clear
      end
      
      def empty?
        @steps.empty?
      end
    end
  end
end
