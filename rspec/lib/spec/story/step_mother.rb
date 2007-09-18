module Spec
  module Story
    class StepMother
      def initialize
        @steps = Hash.new do |hsh,type|
          hsh[type] = Hash.new do |hsh,name|
            SimpleStep.new(name) do
              raise Spec::DSL::ExamplePendingError.new("Unimplemented step: #{name}")
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
